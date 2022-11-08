//
//  CMAcceleration+Extensions.swift
//  Grandpax
//
//  Created by Alex Albu on 08.11.2022.
//

import CoreMotion
import Foundation

extension CMAcceleration {
    func isGreater(than acceleration: CMAcceleration) -> Bool {
        let currentAcceleration = abs(x) + abs(y) + abs(z)
        let maximumAcceleration = abs(acceleration.x) + abs(acceleration.y) + abs(acceleration.z)
        return currentAcceleration > maximumAcceleration
    }
}
