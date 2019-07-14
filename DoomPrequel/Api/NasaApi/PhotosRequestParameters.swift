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
        var date: Date
        var camera: String
        
        init(with rover: Rover, camera: Camera, date: Date) {
            self.roverName = rover.name
            self.date = date
            self.camera = camera.name
            _parameters = parameters
        }
        
        private var _parameters: JSON = [:]
        var parameters: JSON {
            var result = _parameters
            result["earth_date"] = DPDateFormatters.default.string(from: date)
            result["camera"] = camera.lowercased()
            
            return result
        }
        
        mutating func integrate(value: Any, for key: String) {
            _parameters[key] = value
        }
    }
}
