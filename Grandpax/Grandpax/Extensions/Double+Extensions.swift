//
//  Double+Extensions.swift
//  Grandpax
//
//  Created by Alex Albu on 09.11.2022.
//

import Foundation

extension Double {
    func convertFromMs() -> Double {
        // If self is less than 0, it means that there was an error recording the speed
        // I think it is okay to handle this here because this method is only used for converting speed units, which cannot be in the negatives
        if self < 0 { return 0 }
        return self * (UserDefaultsManager.Settings.isImperialUnitsSelected ? 2.23694 : 3.6)
    }
}
