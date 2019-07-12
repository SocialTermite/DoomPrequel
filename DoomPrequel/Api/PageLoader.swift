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
    
    var requestExecutor: (RequestParameters) -> Observable<[T]>
    
    private var requestParameters: RequestParameters
    
    private(set) var page: Int = 0
    
    
    
    init(params: RequestParameters, requestExecutor: @escaping (RequestParameters) -> Observable<[T]>) {
        self.requestParameters = params
        self.requestExecutor = requestExecutor
    }
    
    func newPage() -> Observable<[T]> {
        requestParameters.integrate(value: page, for: "page")
        return requestExecutor(requestParameters)
            .do(onNext: { [weak self] result in
                if !result.isEmpty {
                    self?.page += 1
                }
            })
    }
    
    func reset() {
        page = 0
    }
}
