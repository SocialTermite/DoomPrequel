//
//  NASARoverApi.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 12.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class NASARoverApi: MarsRoverApi {
    private let provider: MoyaProvider<NASAService>
    private let serializer: Serializer
    
    init(serializer: Serializer) {
        self.serializer = serializer
        
        let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
            var request: URLRequest = try! endpoint.urlRequest()
            // this is the important line, because NASAApi may response with 304 error
            request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            done(.success(request))
        }
        provider = MoyaProvider(requestClosure: requestClosure)
    }
    
    func rovers() -> Observable<[Rover]> {
        let response = provider
            .rx
            .request(.rovers)
            .asObservable()
        
        return serializer
            .serializeArrayFromDict(rootKey: Constants.API.ResponseRootKey.rovers.rawValue, response)
    }

    func photos(for rover: Rover, with camera: Camera, at date: Date) -> PageLoader<Photo> {
        let photosParameters = NASAService.PhotosRequestParameters(with: rover,
                                                                   camera: camera,
                                                                   date: date)
        
        return PageLoader<Photo>(params: photosParameters) { [weak self] in
            return self?.photosRequestExecutor($0) ?? .empty()
        }
    }
    
    private func photosRequestExecutor(_ parameters: RequestParameters) -> Observable<[Photo]>? {
        guard let params = parameters as? NASAService.PhotosRequestParameters else {
            return nil
        }
        let token = NASAService.photos(params)
        let response = provider
            .rx
            .request(token)
            .asObservable()
        return serializer
            .serializeArrayFromDict(rootKey: Constants.API.ResponseRootKey.photos.rawValue, response)
    }
}
