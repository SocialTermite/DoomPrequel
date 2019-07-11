//
//  Photo.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 11.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import Foundation

struct Photo {
    var sol: Int
    var date: Date
    var imgSource: URL
}

extension Photo: Decodable {
    private enum PhotoCodingKey: String, CodingKey {
        case sol
        case date = "earth_date"
        case imgSource = "img_scr"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PhotoCodingKey.self)
        
        sol = try container.decode(Int.self, forKey: .sol)
        imgSource = try container.decode(URL.self, forKey: .imgSource)
        
        let dateString = try container.decode(String.self, forKey: .date)

        date = DPDateFormatters.default.date(from: dateString) ?? Date()
        

    }
}
