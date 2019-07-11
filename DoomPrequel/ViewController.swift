//
//  ViewController.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 26.06.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let provider = MoyaProvider<NASAService>()
        provider.request(.rovers) { result in
            switch result {
            case .success(let response):
                guard let rovers = try? JSONDecoder().decode([String: [Rover]].self, from: response.data) else {
                    return
                }
                
                
                print(rovers)
            default: break
                
            }
        }
        // Do any additional setup after loading the view.
    }


}

