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
        AppDelegate.isDarkModeEnabled ? Colors.mediumLightBlue : Colors.mediumStrongBlue
    }
    static var accentBackground: UIColor {
        AppDelegate.isDarkModeEnabled ? Colors.mediumStrongBlue : Colors.mediumLightBlue
    }
    static var background: UIColor {
        AppDelegate.isDarkModeEnabled ? Colors.strongBlue : Colors.lightBlue
    }
    static var tintColor: UIColor {
        AppDelegate.isDarkModeEnabled ? Colors.lightBlue : Colors.strongBlue
    }
}
