//
//  Rover.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 10.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import Foundation

struct Rover {
    let name: String
    let landingDate: Date
    let launchDate: Date
    let status: String
    let maxSOL: Int
    let maxDate: Date
    let totalPhotos: Int
    let cameras: [Camera]
}

extension Rover: Decodable {
    private enum RoverCodingKeys: String, CodingKey {
        case name
        case landingDate = "landing_date"
        case launchDate = "launch_date"
        case status
        case maxSOL = "max_sol"
        case maxDate = "max_date"
        case totalPhotos = "total_photos"
        case cameras
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RoverCodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        status = try container.decode(String.self, forKey: .status)
        maxSOL = try container.decode(Int.self, forKey: .maxSOL)
        
        totalPhotos = try container.decode(Int.self, forKey: .totalPhotos)
        cameras = try container.decode([Camera].self, forKey: .cameras)
        
        let landingDateString = try container.decode(String.self, forKey: .landingDate)
        let launchDateString = try container.decode(String.self, forKey: .launchDate)
        let maxDateString = try container.decode(String.self, forKey: .maxDate)
        
        let dateFormatter = DPDateFormatters.default
        
        landingDate = dateFormatter.date(from: landingDateString) ?? Date()
        launchDate = dateFormatter.date(from: launchDateString) ?? Date()
        maxDate = dateFormatter.date(from: maxDateString) ?? Date()
    }
    
    
}
