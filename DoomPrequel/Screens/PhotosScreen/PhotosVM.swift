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
    private let trash = DisposeBag()
    
    private let api: ApiClient
    private let userCache: UserCache
    private let rover: Rover
    private let router: PhotosRouter

    private lazy var pageLoader: PageLoader<Photo> = self.createPageLoader()
    
    private var photos: BehaviorRelay<[Photo]> = .init(value: [])
    private var apiError: BehaviorRelay<Error?> = .init(value: nil)
    private var isLoading: BehaviorRelay<Bool> = .init(value: false)
    
    var photosObservable: Observable<[Photo]> {
        return photos.asDriver(onErrorJustReturn: []).asObservable().observeOn(MainScheduler.instance)
    }
    
    var errorObservable: Observable<Error> {
        return apiError.compactMap({ $0 }).asObservable().observeOn(MainScheduler.instance)
    }
    
    var isLoadingObservable: Observable<Bool> {
        return isLoading.skip(1).observeOn(MainScheduler.instance).observeOn(MainScheduler.instance)
    }
    
    init(api: ApiClient, userCache: UserCache, rover: Rover, router: PhotosRouter) {
        self.api = api
        self.userCache = userCache
        self.rover = rover
        self.router = router
        
        loadNewPage()
    }
    
    func backToRoverSelection() {
        router.close()
    }
    
    func createPageLoader() -> PageLoader<Photo> {
        return api.photos(for: rover, with: selectedCamera, at: selectedDate)
    }
    
    func loadNewPage() {
        guard !pageLoader.endReached else {
            return
        }
        
        isLoading.accept(true)
        
        pageLoader
            .newPage()
            .asDriver(onErrorRecover: {[weak self] error in
                self?.apiError.accept(error)
                return .just([])
            }) 
            .drive(onNext: {[weak self] photos in
                guard var oldPhotos = self?.photos.value else {
                    return
                }
                oldPhotos.append(contentsOf: photos)
                self?.photos.accept(oldPhotos)
                self?.isLoading.accept(false)
            })
            .disposed(by: trash)
    }
    
    func rowPresented(_ row: Int) {
        let photosLoaded = photos.value.count
        if row == photosLoaded - 1 {
            loadNewPage()
        }
    }
    
    private func resetPageLoader() {
        photos.accept([])
        pageLoader = createPageLoader()
        loadNewPage()
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
    
    var roverName: String {
        return rover.name
    }

    var selectedDate: Date {
        get {
            guard let date = userCache.selectedDate(for: rover) else {
                userCache.selected(date: landingDate, for: rover)
                return landingDate
            }
            return date
        }
        set {
            userCache.selected(date: newValue, for: rover)
            resetPageLoader()
        }
    }
    
    var selectedCamera: Camera {
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
            resetPageLoader()
        }
    }
}
