//
//  MKMapView+Extensions.swift
//  Grandpax
//
//  Created by Alex Albu on 05.11.2022.
//

import MapKit

extension MKMapView {
    
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
      }
}
