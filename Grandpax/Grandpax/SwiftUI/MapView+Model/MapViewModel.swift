//
//  MapViewModel.swift
//  Grandpax
//
//  Created by Alex Albu on 30.11.2022.
//

import SwiftUI
import MapKit

class MapViewModel: ObservableObject {

    @Published var locations = [CLLocationCoordinate2D]()

    private var mapView: MKMapView?

    func drawLine(_ coordinates: [CLLocationCoordinate2D]) {
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView?.addOverlay(polyline)
    }
    
    func setCentralLocation(_ location: CLLocationCoordinate2D) {
        mapView?.setCenter(location, animated: true)
    }

    func injectMapView(_ mapView: MKMapView) {
        self.mapView = mapView
    }
}
