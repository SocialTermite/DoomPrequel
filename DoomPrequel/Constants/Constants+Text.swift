//
//  Constant+Text.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 15.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import UIKit

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
