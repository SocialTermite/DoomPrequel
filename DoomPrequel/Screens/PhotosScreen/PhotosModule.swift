//
//  PhotosModule.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 12.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import UIKit

class PhotosModule {
    var viewController: PhotosVC
    var router: PhotosRouter
    init(rover: Rover) {
        viewController = DIContainer.shared.photosVC(for: rover)
        router = DIContainer.shared.photosRouter()
        router.viewController = viewController
    }
}
