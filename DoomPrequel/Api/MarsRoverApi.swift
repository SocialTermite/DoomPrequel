//
//  MarsRoverApi.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 11.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import Foundation
import RxSwift

protocol MarsRoverApi {
    func rovers() -> Observable<[Rover]>
    func photos(for rover: Rover, with camera: Camera, at date: Date) -> PageLoader<Photo>
}
