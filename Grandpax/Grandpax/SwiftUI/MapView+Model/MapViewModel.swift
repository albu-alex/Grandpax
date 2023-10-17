//
//  MapViewModel.swift
//  Grandpax
//
//  Created by Alex Albu on 30.11.2022.
//

import SwiftUI
import MapKit

class MapViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private var userTrackingMode: MKUserTrackingMode = UserDefaultsManager.Settings.isFollowingCurrentLocation ? .follow : .none {
        didSet {
            guard userTrackingMode == .follow else { return }
            mapView?.setUserTrackingMode(.follow, animated: true)
        }
    }
    private var mapView: MKMapView?
    private var locations = [CLLocationCoordinate2D]()
    
    private let options = MKMapSnapshotter.Options()
    private let DEFAULT_REGION_SPAN = 0.5
    
    // MARK: - Lifecycle
    
    init() {
        setupObservers()
    }
    
    // MARK: - Methods

    func drawLine(_ coordinates: [CLLocationCoordinate2D]) {
        locations = coordinates
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
            let pointsOnImage = locations.map { imageSnapshot.point(for: $0) }
            let image = UIImage.drawPointsOnImage(imageSnapshot.image, points: pointsOnImage)
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
        options.region = calculateRegionToFitOverlay(locations)
        options.mapType = .mutedStandard
        options.showsBuildings = true
        options.size = .init(width: 450, height: 800)
    }
    
    private func calculateRegionToFitOverlay(_ coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        guard !coordinates.isEmpty else {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 52.239647, longitude: 21.045845),
                span: MKCoordinateSpan(latitudeDelta: DEFAULT_REGION_SPAN, longitudeDelta: DEFAULT_REGION_SPAN)
            )
        }

        let latitudes = coordinates.map { $0.latitude }
        let longitudes = coordinates.map { $0.longitude }
        let minLat = latitudes.min()!
        let maxLat = latitudes.max()!
        let minLong = longitudes.min()!
        let maxLong = longitudes.max()!

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2.0,
            longitude: (minLong + maxLong) / 2.0
        )

        let span = MKCoordinateSpan(
            latitudeDelta: maxLat - minLat + 0.01,
            longitudeDelta: maxLong - minLong + 0.01
        )

        return MKCoordinateRegion(center: center, span: span)
    }
    
    @objc
    private func locationCenteringDidChange(_ notification: NSNotification) {
        guard let isCenteringLocation = notification.userInfo?["isCenteringLocation"] as? Bool else { return }
        userTrackingMode = isCenteringLocation ? .follow : .none
    }
}
