//
//  Double+Extensions.swift
//  Grandpax
//
//  Created by Alex Albu on 09.11.2022.
//

import Foundation

extension Double {
    func convertFromMs() -> Double {
        self * (UserDefaultsManager.Settings.isImperialUnitsSelected ? 2.23694 : 3.6)
    }
}
