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
            return userDefaults.codableObject(forKey: Constants.StorageKey.selectedCameras.rawValue)
        }
        set {
            userDefaults.set(try! PropertyListEncoder().encode(newValue), forKey: Constants.StorageKey.selectedCameras.rawValue)
        }
    }
    
    private var selectedDates: [String: Date]? { // roverName: Date
        get {
            return userDefaults.dictionary(forKey: Constants.StorageKey.selectedDates.rawValue) as? [String: Date]
        }
        set {
            userDefaults.set(newValue, forKey: Constants.StorageKey.selectedDates.rawValue)
        }
    }
    
    func selectedCamera(for rover: Rover) -> Camera? {
        return selectedCameras?[rover.name]
    }
    
    func selectedDate(for rover: Rover) -> Date? {
        return selectedDates?[rover.name]
    }
    
    func selected(camera: Camera, for rover: Rover) {
        selectedCameras = set(value: camera, for: rover.name, in: selectedCameras)
    }

    func selected(date: Date, for rover: Rover) {
        selectedDates = set(value: date, for: rover.name, in: selectedDates)
    }
    
    private func set<T>(value: T, for key: String, in source: [String: T]?) -> [String: T] {
        var dict = source ?? [:]
        dict[key] = value
        return dict
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
