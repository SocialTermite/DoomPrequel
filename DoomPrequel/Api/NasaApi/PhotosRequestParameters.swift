//
//  PhotosRequestParameters.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 12.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import Foundation

extension NASAService {
    struct PhotosRequestParameters: RequestParameters {
        var roverName: String
        var sol: Int = 0
        var date: Date?
        var camera: String
        
        init(with rover: Rover, camera: Camera, marsDate: MarsDate) {
            self.roverName = rover.name
            if case .sol(let sol) = marsDate {
                self.sol = sol
            } else if case .earthDate(let date) = marsDate {
                self.date = date
            }
            self.camera = camera.name
            _parameters = parameters
        }
        
        private var _parameters: JSON = [:]
        var parameters: JSON {
            var result = _parameters
            result["camera"] = camera
            if let date = date {
                result["earth_date"] = DPDateFormatters.default.string(from: date)
            } else {
                result["sol"] = sol
            }
            
            return result
        }
        
        mutating func integrate(value: Any, for key: String) {
            _parameters[key] = value
        }
    }
}
