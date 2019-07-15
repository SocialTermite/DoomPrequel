//
//  PageLoader.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 12.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import Foundation
import RxSwift

class PageLoader<T> {
    
    private let requestExecutor: (RequestParameters) -> Observable<[T]>
    
    private var requestParameters: RequestParameters
    
    private(set) var page: Int = 0
    
    private(set) var endReached: Bool = false
    
    init(params: RequestParameters,
         requestExecutor: @escaping (RequestParameters) -> Observable<[T]>) {
        self.requestParameters = params
        self.requestExecutor = requestExecutor
    }
    
    func newPage() -> Observable<[T]> {
        guard !endReached else {
            return .just([])
        }
        requestParameters.integrate(value: page,
                                    for: Constants.API.Parameters.page.rawValue)
        
        return requestExecutor(requestParameters)
            .do(onNext: { [weak self] result in
                if result.count < Constants.API.pageLimit {
                    self?.endReached = true
                } else {
                    self?.page += 1
                }
            })
    }
    
    func reset() {
        page = 0
        endReached = false
    }
}
