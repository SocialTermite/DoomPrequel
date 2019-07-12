//
//  PhotosRoute.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 12.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import Foundation

protocol PhotosRoute {
    var photosTransition: Transition { get }
    func openPhotos(with rover: Rover)
}

extension PhotosRoute where Self: RouterProtocol {
    func openPhotos(with rover: Rover) {
        let photosModule = PhotosModule(rover: rover)
        photosModule.router.openTransition = photosTransition
        open(photosModule.viewController, transition: photosTransition)
    }
}
