//
//  SettingsViewModelTests.swift
//  GrandpaxTests
//
//  Created by Alex Albu on 18.06.2023.
//

import XCTest
@testable import Grandpax

class SettingsViewModelTests: XCTestCase {
    
    var viewModel: SettingsViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = SettingsViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testIsImperialUnitsSelected() {
        // Initially, the value should be the same as UserDefaults
        XCTAssertEqual(viewModel.isImperialUnitsSelected, UserDefaultsManager.Settings.isImperialUnitsSelected)
        
        // Update the value
        viewModel.isImperialUnitsSelected = true
        
        // Verify that the value is updated in UserDefaults
        XCTAssertEqual(UserDefaultsManager.Settings.isImperialUnitsSelected, true)
        
        // Verify that the value is updated in the view model
        XCTAssertEqual(viewModel.isImperialUnitsSelected, true)
    }
    
    func testIsSavingTrackingData() {
        // Initially, the value should be the same as UserDefaults
        XCTAssertEqual(viewModel.isSavingTrackingData, UserDefaultsManager.Settings.isSavingTrackingData)
        
        // Update the value
        viewModel.isSavingTrackingData = true
        
        // Verify that the value is updated in UserDefaults
        XCTAssertEqual(UserDefaultsManager.Settings.isSavingTrackingData, true)
        
        // Verify that the value is updated in the view model
        XCTAssertEqual(viewModel.isSavingTrackingData, true)
    }
    
    func testIsFollowingCurrentLocation() {
        // Initially, the value should be the same as UserDefaults
        XCTAssertEqual(viewModel.isFollowingCurrentLocation, UserDefaultsManager.Settings.isFollowingCurrentLocation)
        
        // Update the value
        viewModel.isFollowingCurrentLocation = true
        
        // Verify that the value is updated in UserDefaults
        XCTAssertEqual(UserDefaultsManager.Settings.isFollowingCurrentLocation, true)
        
        // Verify that the value is updated in the view model
        XCTAssertEqual(viewModel.isFollowingCurrentLocation, true)
    }
}
