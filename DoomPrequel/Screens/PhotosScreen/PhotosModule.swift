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
        router = PhotosRouter()
        let serializer = NASASerializer()
        let marsRoverApi = NASARoverApi(serializer: serializer)
        let apiClient = ApiClient(roverApi: marsRoverApi)
        let viewModel = PhotosVM(api: apiClient, userCache: UserCache(), rover: rover, router: router)
        viewController = PhotosVC(viewModel: viewModel)
        
        self.router.viewController = viewController
    }
}
