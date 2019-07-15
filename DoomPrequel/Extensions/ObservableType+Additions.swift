//
//  ObservableType+Additions.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 15.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    func compactMap<T>(_ transform: @escaping (E) throws -> T?) -> Observable<T> {
        return flatMap { try transform($0).flatMap(Observable.just) ?? .empty() }
    }
}
