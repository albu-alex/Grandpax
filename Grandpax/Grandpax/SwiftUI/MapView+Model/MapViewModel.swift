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
    private let options = MKMapSnapshotter.Options()
    
    // MARK: - Lifecycle
    
    init() {
        setupObservers()
    }
    
    // MARK: - Methods

    func drawLine(_ coordinates: [CLLocationCoordinate2D]) {
        mapView?.setUserTrackingMode(userTrackingMode, animated: true)
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        if let overlay = mapView?.overlays.first {
            mapView?.removeOverlay(overlay)
        }
        mapView?.addOverlay(polyline)
    }

    func injectMapView(_ mapView: MKMapView) {
        self.mapView = mapView
    }
    
    func createSnapshot() async -> String? {
        setupSnapshotter()
        let snapshotter = MKMapSnapshotter(options: options)

        do {
            let imageSnapshot = try await snapshotter.start()
            let image = UIImage.drawRectangleOnImage(imageSnapshot.image)
            let imageData = image.jpegData(compressionQuality: 0.8)?.base64EncodedString()
            return imageData
        } catch {
            print("Something went wrong: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(locationCenteringDidChange(_:)), name: Notification.Name("LocationCenteringDidChange"), object: nil)
    }
    
    private func setupSnapshotter() {
        options.region = mapView?.region ?? MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 52.239647, longitude: 21.045845),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
        options.mapType = .mutedStandard
        options.showsBuildings = true
    }
    
    @objc
    private func locationCenteringDidChange(_ notification: NSNotification) {
        guard let isCenteringLocation = notification.userInfo?["isCenteringLocation"] as? Bool else { return }
        userTrackingMode = isCenteringLocation ? .follow : .none
    }
}
