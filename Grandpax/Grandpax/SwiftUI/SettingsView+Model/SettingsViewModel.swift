//
//  SettingsViewModel.swift
//  Grandpax
//
//  Created by Alex Albu on 01.12.2022.
//

import SwiftUI
import LocalAuthentication

final class SettingsViewModel: ObservableObject {
    
    // MARK: - States
    @Published var isImperialUnitsSelected = UserDefaultsManager.Settings.isImperialUnitsSelected {
        didSet {
            UserDefaultsManager.Settings.isImperialUnitsSelected = isImperialUnitsSelected
        }
    }
    @Published var isSavingTrackingData = UserDefaultsManager.Settings.isSavingTrackingData {
        didSet {
            UserDefaultsManager.Settings.isSavingTrackingData = isSavingTrackingData
        }
    }
    @Published var isFollowingCurrentLocation = UserDefaultsManager.Settings.isFollowingCurrentLocation {
        didSet {
            UserDefaultsManager.Settings.isFollowingCurrentLocation = isFollowingCurrentLocation
        }
    }
    
    @Published var isFaceIDEnabled = UserDefaultsManager.Settings.isFaceIDEnabled {
        didSet {
            guard oldValue else {
                UserDefaultsManager.Settings.isFaceIDEnabled = isFaceIDEnabled
                return
            }
            let biometricsCompletion: BiometricsCompletion = { success, error in
                guard error != nil else { return }
                self.isFaceIDEnabled = true
            }
            BiometricsManager.faceIDSecurity(completion: biometricsCompletion)
        }
    }
}
