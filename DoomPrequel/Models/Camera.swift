//
//  Camera.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 10.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import Foundation

struct Camera {
    var name: String
    var fullName: String
}

extension Camera: Decodable {
    private enum CameraCodingKey: String, CodingKey {
        case name
        case fullName = "full_name"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CameraCodingKey.self)
        
        name = try container.decode(String.self, forKey: .name)
        fullName = try container.decode(String.self, forKey: .fullName)
    }
}



