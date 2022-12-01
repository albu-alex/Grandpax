//
//  SettingsViewModel.swift
//  Grandpax
//
//  Created by Alex Albu on 01.12.2022.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    
    // MARK: - States
    @Published var isImperialUnitsSelected = false
    @Published var isSavingTrackingData = true
    @Published var isFollowingCurrentLocation = true
}
