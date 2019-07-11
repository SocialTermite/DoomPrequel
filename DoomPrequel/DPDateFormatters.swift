//
//  DateFormatter.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 11.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import Foundation

class DPDateFormatters {
    static var `default`: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormat.default.rawValue
        return dateFormatter
    }()
}
