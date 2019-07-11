//
//  NASASerializer.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 12.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol Serializer {
    func serializeArrayFromDict<Type: Decodable>(rootKey: String, _ response: Observable<Response>) -> Observable<[Type]>
}

class NASASerializer: Serializer {
    func serializeArrayFromDict<Type: Decodable>(rootKey: String, _ response: Observable<Response>) -> Observable<[Type]> {
        return response
            .map { try JSONDecoder().decode([String: [Type]].self, from: $0.data) }
            .compactMap { $0[rootKey] }
    }
}
