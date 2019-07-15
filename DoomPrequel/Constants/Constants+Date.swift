//
//  Constants+Date.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 15.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import Foundation

extension Constants {
    enum Date {
        static var dateFormat: String {
            return "YYYY-MM-dd"
        }
        
        enum Formatters {
            case `default`
            
            func formatter() -> DateFormatter {
                switch self {
                case .default:
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = Date.dateFormat
                    return dateFormatter
                }
            }
        }
    }
}
