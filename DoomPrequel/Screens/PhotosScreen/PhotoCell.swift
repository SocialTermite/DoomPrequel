//
//  PhotoCell.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 12.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import JGProgressHUD

class PhotoCell: UITableViewCell {    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var tapButton: UIButton!
    
    var tabObservable: Observable<UIImageView> {
        return tapButton.rx.tap.asObservable().map {  self.photoImageView } 
    }
    
    var isDownloaded: () -> Void = { }
    
    func setup(with photo: Photo) {
        photoImageView.kf.indicatorType = .activity
        photoImageView.kf.setImage(with:  ImageResource(downloadURL: photo.imgSource), placeholder: nil, options: [.fromMemoryCacheOrRefresh, .transition(.fade(1)), .scaleFactor(UIScreen.main.scale)]) {[weak self] _, _, _, _ in
            self?.isDownloaded()
        }
    }
    
}
