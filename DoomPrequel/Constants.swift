//
//  Constants.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 11.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import UIKit

class Constants {
    
}

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

extension Constants {
    enum TableView {
        enum CellIdentifier: String {
            case rover = "RoverCell"
            case photo = "PhotoCell"
        }
    }
}

extension Constants {
    enum DateFormat: String {
        case `default` = "YYYY-MM-dd"
    }
}

extension Constants {
    enum Font {
        case h1
        case h2
        case h3
        
        func font() -> UIFont {
            switch self {
            case .h1:
                return UIFont(name: "NotoSerif", size: 22)!
            case .h2:
                return UIFont(name: "NotoSerif", size: 16)!
            case .h3:
                return UIFont(name: "NotoSerif", size: 12)!
            }
            
        }
    }
    
    enum Text: String, Hashable {
        case errorText
        case errorTitle
        case selectRover
        case launchDate
        case landingDate
        case status
        case totalPhotos
        case emptyResult
        case rover
        
        func localized() -> String {
            ///TODO: Add localization
            ///      and move to plist
            let textPair: [Text: String] = [
                .errorText: "Something went wrong",
                .errorTitle: "Forgive us",
                .selectRover: "Select Rover,\n to start exploring mars photos",
                .launchDate: "Launch date",
                .landingDate: "Landing date",
                .status: "Status",
                .totalPhotos: "Total photos",
                .emptyResult: "Sorry, nothing found for this date\nSelect other date or camera",
                .rover: "Rover"
            ]
            return textPair[self] ?? "Add value to localization \(self.rawValue)"
        }
    }
}

extension Constants {
    enum StorageKey: String {
        case selectedRover
        case selectedCameras
        case selectedDates
    }
}

extension Constants {
    enum Rover: String {
        case curiosity
        case spirit
        case opportunity
        
        func image() -> UIImage {
            switch self {
            case .curiosity:
                return UIImage(named: "curiosity")!
            case .spirit:
                return UIImage(named: "spirit")!
            case .opportunity:
                return UIImage(named: "opportunity")!
            }
        }
    }
}
