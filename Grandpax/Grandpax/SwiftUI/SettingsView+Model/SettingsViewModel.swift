//
//  SettingsViewModel.swift
//  Grandpax
//
//  Created by Alex Albu on 01.12.2022.
//

import SwiftUI

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
}
