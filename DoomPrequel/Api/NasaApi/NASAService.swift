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
        var requestParameters: JSON = ["api_key": NASAService.apiKey]
        switch self {
        case .rovers:
            return .requestParameters(parameters: requestParameters, encoding: URLEncoding.queryString)
        case .photos(let photosParameters):
            requestParameters.merge(dict: photosParameters.parameters)
            return .requestParameters(parameters: requestParameters, encoding: URLEncoding.queryString)
        }
        
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    static private let apiKey = "rfFEHRMpDhqQ8nXM9zyuObcA8glQ8ZJFoXQ8Qi7O"
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
