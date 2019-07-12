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

extension Camera: Codable {
    private enum CameraCodingKey: String, CodingKey {
        case name
        case fullName = "full_name"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CameraCodingKey.self)
        try container.encode(name, forKey: .name)
        try container.encode(fullName, forKey: .fullName)
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CameraCodingKey.self)
        
        name = try container.decode(String.self, forKey: .name)
        fullName = try container.decode(String.self, forKey: .fullName)
    }
}



