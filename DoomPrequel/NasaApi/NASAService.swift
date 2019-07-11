//
//  NASA.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 26.06.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//
import Foundation
import Moya

enum NASAService: TargetType {
    case rovers
    case photos(PhotosRequestParameters)
    
    public var baseURL: URL {
        return URL(string: "https://api.nasa.gov/mars-photos/api/v1/")!
    }
    
    public var path: String {
        switch self {
        case .rovers: return "/rovers"
        case .photos(let parameters): return "\(parameters.roverName)/photos"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task  {
        let requestParameters = ["api_key": NASAService.apiKey]
        switch self {
        case .rovers:
            return .requestParameters(parameters: requestParameters, encoding: URLEncoding.queryString)
        case .photos(let parameters):
            return .requestParameters(parameters: parameters.integrate(into: requestParameters), encoding: URLEncoding.queryString)
        }
        
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    static private let apiKey = "rfFEHRMpDhqQ8nXM9zyuObcA8glQ8ZJFoXQ8Qi7O"
}

extension NASAService {
    struct PhotosRequestParameters {
        var roverName: String
        var sol: Int = 0
        var date: Date?
        var camera: String
        var page: Int = 0
        func integrate(into source: [String: Any]) -> [String: Any] {
            var source = source
            source["camera"] = camera
            source["page"] = page
            if let date = date {
                source["earth_date"] = DPDateFormatters.default.string(from: date)
            } else {
                source["sol"] = sol
            }
            
            return source
        }
    }
}

extension Date {
    func dateString(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

