//
//  RoverCell.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 12.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import UIKit

class RoverCell: UITableViewCell {

    @IBOutlet var roverImageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var launchDateLabel: UILabel!
    @IBOutlet var landingLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var totalPhotosLabel: UILabel!
    
    
    func setup(with rover: Rover) {
        nameLabel.text = rover.name
        launchDateLabel.text = "Launch date: \(DPDateFormatters.default.string(from: rover.launchDate))"
        landingLabel.text = "Landing date: \(DPDateFormatters.default.string(from: rover.landingDate))"
        statusLabel.text = "Status: \(rover.status)"
        totalPhotosLabel.text = "Total photos: \(rover.totalPhotos)"
        setHardcoderImages(for: rover)
    }
    
    func setHardcoderImages(for rover: Rover) {
        roverImageView.image = Constants.Rover(rawValue: rover.name.lowercased())?.image()
        roverImageView.layer.cornerRadius = 51.5
        roverImageView.clipsToBounds = true
        roverImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
}