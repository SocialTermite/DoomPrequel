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
import RxCocoa


class NASARoverApi {
//    func rovers() -> Observable<Rover> {
//        return .just()
//    }
//
//    func photos(for rover: Rover, with camera: Camera, at: MarsDate) -> Observable<[Photo]> {
//        <#code#>
//    }
    
    private let provider = MoyaProvider<NASAService>()
    
    init() {
        provider.rx
    }
}
