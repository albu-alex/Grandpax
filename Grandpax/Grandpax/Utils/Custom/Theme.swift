//
//  Theme.swift
//  Grandpax
//
//  Created by Alex Albu on 24.12.2022.
//

import UIKit

struct Theme {
    static var textColor: UIColor {
        AppDelegate.isDarkModeEnabled ? Colors.white : Colors.black
    }
    static var accentColor: UIColor {
        AppDelegate.isDarkModeEnabled ? Colors.mediumLightGreen : Colors.mediumStrongGreen
    }
    static var accentBackground: UIColor {
        AppDelegate.isDarkModeEnabled ? Colors.mediumStrongGreen : Colors.mediumLightGreen
    }
    static var background: UIColor {
        AppDelegate.isDarkModeEnabled ? Colors.strongGreen : Colors.lightGreen
    }
    static var tintColor: UIColor {
        AppDelegate.isDarkModeEnabled ? Colors.lightGreen : Colors.strongGreen
    }
}
