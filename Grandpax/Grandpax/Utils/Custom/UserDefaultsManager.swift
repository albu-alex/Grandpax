//
//  UserDefaultsManager.swift
//  Grandpax
//
//  Created by Alex Albu on 01.12.2022.
//

import Foundation

enum UserDefaultsManager {
    enum Settings {
        @UserDefault("\(Self.self)ImperialUnitsSelected", defaultValue: false)
        static var isImperialUnitsSelected: Bool
        
        @UserDefault("\(Self.self)SavingTrackingData", defaultValue: true)
        static var isSavingTrackingData: Bool
        
        @UserDefault("\(Self.self)FollowingCurrentLocation", defaultValue: true)
        static var isFollowingCurrentLocation: Bool
    }
}

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
