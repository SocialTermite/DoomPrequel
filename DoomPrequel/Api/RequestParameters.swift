//
//  RequestParameters.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 12.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

protocol RequestParameters {
    var parameters: JSON { get }
    mutating func integrate(value: Any, for key: String)
}
