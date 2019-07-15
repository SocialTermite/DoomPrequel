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
        return Constants.API.url
    }
    
    public var path: String {
        let rovers = "\(Constants.API.Path.rovers)"
        let photos = "\(Constants.API.Path.photos)"
        switch self {
        case .rovers: return "/\(rovers)"
        case .photos(let parameters): return "/\(rovers)/\(parameters.roverName.lowercased())/\(photos)"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    public var task: Task  {
        var requestParameters: JSON = [Constants.API.Parameters.apiKey.rawValue: Constants.API.Parameters.NASAKey]
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
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
