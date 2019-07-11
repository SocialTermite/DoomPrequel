//
//  ApiClient.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 11.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import Foundation
import RxSwift

class ApiClient {
    private let roverApi: MarsRoverApi
    
    init(roverApi: MarsRoverApi) {
        self.roverApi = roverApi
    }
    
    func rovers() -> Observable<[Rover]> {
        return roverApi.rovers()
    }
    
    func photos(for rover: Rover, with camera: Camera, at marsDate: MarsDate) -> PageLoader<Photo> {
        return roverApi.photos(for: rover, with: camera, at: marsDate)
    }
}
