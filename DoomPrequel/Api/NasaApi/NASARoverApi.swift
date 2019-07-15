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
            // this is the important line
            request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            done(.success(request))
        }
        provider = MoyaProvider(requestClosure: requestClosure)
    }
    
    func rovers() -> Observable<[Rover]> {
        let response = provider.rx.request(.rovers).asObservable()
        return serializer.serializeArrayFromDict(rootKey: Constants.API.ResponseRootKey.rovers.rawValue, response)
    }

    func photos(for rover: Rover, with camera: Camera, at date: Date) -> PageLoader<Photo> {
        let photosParameters = NASAService.PhotosRequestParameters.init(with: rover, camera: camera, date: date)
        
        return PageLoader<Photo>(params: photosParameters) { [provider, serializer] in
            guard let params = $0 as? NASAService.PhotosRequestParameters else {
                return .empty()
            }
            let token = NASAService.photos(params)
            let response = provider
                .rx
                .request(token)
                .asObservable()
            return serializer.serializeArrayFromDict(rootKey: Constants.API.ResponseRootKey.photos.rawValue, response)
        }
        
    }
}


extension ObservableType {
    func compactMap<T>(_ transform: @escaping (E) throws -> T?) -> Observable<T> {
        return flatMap { try transform($0).flatMap(Observable.just) ?? .empty() }
    }
}
