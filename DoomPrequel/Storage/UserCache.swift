//
//  UserCache.swift
//  DoomPrequel
//
//  Created by Konstantin Bondar on 12.07.19.
//  Copyright © 2019 SocialTermite. All rights reserved.
//

import Foundation

class UserCache {
    let userDefaults = UserDefaults.standard
    
    var selectedRover: Rover? {
        get {
            
            return userDefaults.codableObject(forKey: Constants.StorageKey.selectedRover.rawValue)
        }
        set {
            userDefaults.set(try! PropertyListEncoder().encode(newValue), forKey: Constants.StorageKey.selectedRover.rawValue)
        }
    }
    
    private var selectedCameras: [String: Camera]? { // roverName: Camera
        get {
            return userDefaults.dictionary(forKey: Constants.StorageKey.selectedCameras.rawValue) as? [String: Camera]
        }
        set {
            userDefaults.set(newValue, forKey: Constants.StorageKey.selectedCameras.rawValue)
        }
    }
    
    func selectedCamera(for rover: Rover) -> Camera? {
        return selectedCameras?[rover.name]
    }
    
    func selected(camera: Camera, for rover: Rover) {
        selectedCameras?[rover.name] = camera
    }
    
    private var selectedDates: [String: Date]? { // roverName: Date
        get {
            return userDefaults.dictionary(forKey: Constants.StorageKey.selectedDates.rawValue) as? [String: Date]
        }
        set {
            userDefaults.set(newValue, forKey: Constants.StorageKey.selectedDates.rawValue)
        }
    }
    
    func selectedDate(for rover: Rover) -> Date? {
        return selectedDates?[rover.name]
    }
    
    func selected(date: Date, for rover: Rover) {
        selectedDates?[rover.name] = date
    }
}

extension UserDefaults {
    func codableObject<Type: Codable>(forKey key: String) -> Type? {
        guard let data = value(forKey: key) as? Data,
            let object = try? PropertyListDecoder().decode(Type.self, from: data) else {
                return nil
        }
        
        return object
    }
}
