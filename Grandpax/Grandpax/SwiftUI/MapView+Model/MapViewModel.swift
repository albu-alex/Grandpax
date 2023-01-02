//
//  MapViewModel.swift
//  Grandpax
//
//  Created by Alex Albu on 30.11.2022.
//

import SwiftUI
import MapKit

class MapViewModel: ObservableObject {
    
    // MARK: - Published

    @Published var locations = [CLLocationCoordinate2D]()
    
    // MARK: - Properties
    
    private var userTrackingMode: MKUserTrackingMode = UserDefaultsManager.Settings.isFollowingCurrentLocation ? .follow : .none {
        didSet {
            guard userTrackingMode == .follow else { return }
            mapView?.setUserTrackingMode(.follow, animated: true)
        }
    }
    private var mapView: MKMapView?
    
    // MARK: - Lifecycle
    
    init() {
        setupObservers()
    }
    
    // MARK: - Methods

    func drawLine(_ coordinates: [CLLocationCoordinate2D]) {
        mapView?.setUserTrackingMode(userTrackingMode, animated: true)
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView?.addOverlay(polyline)
    }

    func injectMapView(_ mapView: MKMapView) {
        self.mapView = mapView
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(locationCenteringDidChange(_:)), name: Notification.Name("LocationCenteringDidChange"), object: nil)
    }
    
    @objc
    private func locationCenteringDidChange(_ notification: NSNotification) {
        guard let isCenteringLocation = notification.userInfo?["isCenteringLocation"] as? Bool else { return }
        userTrackingMode = isCenteringLocation ? .follow : .none
    }
}
