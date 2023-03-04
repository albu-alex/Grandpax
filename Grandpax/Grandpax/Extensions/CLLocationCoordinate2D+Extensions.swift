//
//  CLLocationCoordinate2D+Extensions.swift
//  Grandpax
//
//  Created by Alex Albu on 20.11.2022.
//

import CoreLocation

extension CLLocationCoordinate2D: Hashable, Equatable {
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
        
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}
