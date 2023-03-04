//
//  CMAcceleration+Extensions.swift
//  Grandpax
//
//  Created by Alex Albu on 08.11.2022.
//

import CoreMotion
import Foundation

extension CMAcceleration: Hashable, Equatable {
    var acceleration: Double {
        sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2)) / 9.81
    }
    
    func isGreater(than acceleration: CMAcceleration) -> Bool {
        let currentAcceleration = self.acceleration
        let maximumAcceleration = acceleration.acceleration
        return currentAcceleration > maximumAcceleration
    }
    
    public static func ==(lhs: CMAcceleration, rhs: CMAcceleration) -> Bool {
        return lhs.acceleration == rhs.acceleration
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
    }
}

extension Array where Element == CMAcceleration {
    func sum() -> Double {
        return self.reduce(0.0) { result, acceleration in
            return result + acceleration.acceleration
        }
    }
}
