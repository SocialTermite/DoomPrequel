//
//  Constants+API.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 15.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import Foundation

extension Constants {
    enum API {
        static var url: URL {
            return URL(string: "https://api.nasa.gov/mars-photos/api/v1")!
        }
        
        static var pageLimit: Int {
            return 25
        }
        
        enum Path: String {
            case rovers = "rovers"
            case photos = "photos"
        }
        
        enum Parameters: String {
            case page = "page"
            case apiKey = "api_key"
            static var NASAKey: String {
                return "rfFEHRMpDhqQ8nXM9zyuObcA8glQ8ZJFoXQ8Qi7O"
            }
            case date = "earth_date"
            case camera = "camera"
            
        }
        
        enum ResponseRootKey: String {
            case rovers = "rovers"
            case photos = "photos"
        }
    }
}
