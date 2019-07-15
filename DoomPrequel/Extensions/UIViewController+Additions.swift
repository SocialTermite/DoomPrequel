//
//  UIViewController+Additions.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 15.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import UIKit
import Toast_Swift

extension UIViewController {
    func handleError(error: Error) {
        view.makeToast("\(Constants.Text.errorText.localized()) - \(error.localizedDescription)",
            duration: 3,
            point: view.center,
            title: Constants.Text.errorTitle.localized(),
            image: nil,
            style: ToastStyle.default(),
            completion: nil)
    }
}
