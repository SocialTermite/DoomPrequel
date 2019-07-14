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


class PhotoCell: UITableViewCell {    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var tapButton: UIButton!
    
    var tabObservable: Observable<UIImageView> {
        return tapButton.rx.tap.asObservable().map {  self.photoImageView } 
    }
    
    func setup(with photo: Photo) {
        photoImageView.kf.setImage(with: ImageResource(downloadURL: photo.imgSource))
    }
    
}
