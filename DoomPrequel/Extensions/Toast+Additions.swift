//
//  Toast+Additions.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 15.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import Foundation
import Toast_Swift

extension ToastStyle {
    static func `default`() -> ToastStyle {
        var style = ToastStyle()
        style.titleAlignment = .center
        return style
    }
}
