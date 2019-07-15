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

extension Photo: Codable {
    private enum PhotoCodingKey: String, CodingKey {
        case sol
        case date = "earth_date"
        case imgSource = "img_src"
    }
    
    func encode(to encoder: Encoder) throws {
        let formatter = Constants.Date.Formatters.default.formatter()
        var container = encoder.container(keyedBy: PhotoCodingKey.self)
        try container.encode(sol, forKey: .sol)
        try container.encode(formatter.string(from: date), forKey: .date)
        try container.encode(imgSource, forKey: .imgSource)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PhotoCodingKey.self)
        
        sol = try container.decode(Int.self, forKey: .sol)
        imgSource = try container.decode(URL.self, forKey: .imgSource)
        
        let dateString = try container.decode(String.self, forKey: .date)

        date = Constants.Date.Formatters.default.formatter().date(from: dateString) ?? Date()
    }
}
