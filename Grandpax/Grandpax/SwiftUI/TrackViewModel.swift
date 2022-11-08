//
//  TrackViewModel.swift
//  Grandpax
//
//  Created by Alex Albu on 05.11.2022.
//

import SwiftUI
import MapKit
import CoreMotion
import Foundation

final class TrackViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    var locationManager: CLLocationManager?
    var motionManager: CMMotionManager?
    static private let delta = 0.005
    
    // MARK: - States
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            // Default location is Pula, Croatia
            latitude: 44.8683,
            longitude: 13.8481),
        span: MKCoordinateSpan(
            latitudeDelta: 0.005,
            longitudeDelta: 0.005)
    )
    @Published var acceleration = CMAcceleration()
//    @Published var maximumAcceleration = CMAcceleration()
    
    // MARK: - Methods
    
    func deallocateManagers(completion: @escaping (() -> Void)) {
        locationManager?.stopUpdatingLocation()
        motionManager?.stopAccelerometerUpdates()
        locationManager = nil
        motionManager = nil
        completion()
    }
    
    func startLocationsServices() {
        locationManager = CLLocationManager()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        locationManager?.activityType = .automotiveNavigation
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startAccelerometer() {
        let motionManager = CMMotionManager()
        // Make sure the accelerometer hardware is available.
        guard motionManager.isAccelerometerAvailable else { return }
        motionManager.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
        motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
            guard let acceleration = data?.acceleration else { return }
            self.acceleration = acceleration
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager else { return }
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location is restriced")
        case .denied:
            print("Location is denied")
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }
}

// MARK: - Extensions

extension TrackViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = manager.location?.coordinate else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            withAnimation {
                region.center = coordinate
            }
        }
    }
}
