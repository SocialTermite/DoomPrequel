//
//  RoverSelectionModule.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 12.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import Foundation

class RoverSelectionModule {
    static func module() -> RoverSelectionVC {
        let router = RoverSelectionRouter()
        let serializer = NASASerializer()
        let marsRoverApi = NASARoverApi(serializer: serializer)
        let apiClient = ApiClient(roverApi: marsRoverApi)
        let viewModel = RoverSelectionVM(api: apiClient, userCache: UserCache(), photosRoute: router)
        let viewController = RoverSelectionVC(viewModel: viewModel)
        router.viewController = viewController
        return viewController
    }
}
