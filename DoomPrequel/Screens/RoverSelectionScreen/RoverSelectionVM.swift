//
//  RoverSelectionVM.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 12.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class RoverSelectionVM {
    private let api: ApiClient
    private let userCache: UserCache
    private let trash = DisposeBag()
    private let router: PhotosRoute
    var rovers: BehaviorSubject<[Rover]> = .init(value: [])
    
    init(api: ApiClient, userCache: UserCache, photosRoute: PhotosRoute) {
        self.api = api
        self.userCache = userCache
        self.router = photosRoute
        setupRx()
    }
    
    private func setupRx() {
        api.rovers()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInitiated))
            .asObservable()
            .bind(to: rovers)
            .disposed(by: trash)
    }
    
    func userSelected(_ rover: Rover) {
        userCache.selectedRover = rover
        router.openPhotos(with: rover)
    }
}
