//
//  Date+Additions.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 15.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import Foundation

extension Date {
    func string() -> String {
        let formatter = Constants.Date.Formatters.default.formatter()
        return formatter.string(from: self)
    }
}
