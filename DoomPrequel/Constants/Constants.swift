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
    enum TableView {
        enum CellIdentifier: String {
            case rover = "RoverCell"
            case photo = "PhotoCell"
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
