//
//  PhotosVM.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 12.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PhotosVM {
    private let api: ApiClient
    private let userCache: UserCache
    private let rover: Rover
    private let router: PhotosRouter
    private let trash = DisposeBag()
    
    private lazy var pageLoader: PageLoader<Photo> = self.createPageLoader()
    private var photos: BehaviorRelay<[Photo]> = .init(value: [])
    
    private var photosObservable: Observable<[Photo]> {
        return photos.asObservable().observeOn(MainScheduler.instance)
    }
    
    init(api: ApiClient, userCache: UserCache, rover: Rover, router: PhotosRouter) {
        self.api = api
        self.userCache = userCache
        self.rover = rover
        self.router = router
        
        
    }
    
    func backToRoverSelection() {
        router.close()
    }
    
    func createPageLoader() -> PageLoader<Photo> {
        return api.photos(for: rover, with: selectedCamera, at: selectedDate)
    }
    
    func newPage() {
        pageLoader
            .newPage()
            .bind(onNext: {[weak self] photos in
                guard var oldPhotos = self?.photos.value else {
                    return
                }
                oldPhotos.append(contentsOf: photos)
                self?.photos.accept(oldPhotos)
            })
            .disposed(by: trash)
    }
    
    var cameras: [Camera] {
        return rover.cameras
    }
    
    var landingDate: Date {
        return rover.landingDate
    }
    
    var maxDate: Date {
        return rover.maxDate
    }
    
    var maxSol: Int {
        return rover.maxSOL
    }
    
    var roverName: String {
        return rover.name
    }
    
    private var selectedDate: Date {
        get {
            guard let date = userCache.selectedDate(for: rover) else {
                userCache.selected(date: maxDate, for: rover)
                return maxDate
            }
            return date
        }
        set {
            userCache.selected(date: newValue, for: rover)
        }
    }
    
    private var selectedCamera: Camera {
        get {
            guard let camera = userCache.selectedCamera(for: rover) else {
                guard let camera = cameras.first else {
                    #if DEBUG
                    fatalError("Camera not found")
                    #else
                    return Camera()
                    #endif
                    
                }
                userCache.selected(camera: camera, for: rover)
                return camera
            }
            return camera
        }
        set {
            userCache.selected(camera: newValue, for: rover)
        }
    }
}
