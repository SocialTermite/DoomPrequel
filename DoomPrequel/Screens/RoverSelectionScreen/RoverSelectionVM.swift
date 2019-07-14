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
    var rovers: BehaviorRelay<[Rover]> = .init(value: [])
    private var apiError: BehaviorRelay<Error?> = .init(value: nil)
    var errorObservable: Observable<Error> {
        return apiError.compactMap({ $0 }).asObservable()
    }
    
    
    init(api: ApiClient, userCache: UserCache, photosRoute: PhotosRoute) {
        self.api = api
        self.userCache = userCache
        self.router = photosRoute
        setupRx()
    }
    
    private func setupRx() {
        api.rovers()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInitiated))
            .asDriver(onErrorRecover: {[weak self] error in
                self?.apiError.accept(error)
                return .just([])
            })
            .drive(rovers)
            .disposed(by: trash)
    }
    
    func userSelected(_ rover: Rover) {
        userCache.selectedRover = rover
        router.openPhotos(with: rover)
    }
}
