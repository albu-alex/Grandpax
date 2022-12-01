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

struct Place: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

final class TrackViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    var locationManager: CLLocationManager?
    var motionManager: CMMotionManager?
    var userLocations = [CLLocationCoordinate2D]()
    static private let delta = 0.005
    
    // MARK: - States
    
    @Published var acceleration = CMAcceleration()
    @Published var maximumAcceleration = CMAcceleration()
    @Published var currentSpeed = CLLocationSpeed()
    @Published var maximumSpeed = CLLocationSpeed()
    
    // MARK: - Methods
    
    func deallocateManagers() {
        locationManager?.stopUpdatingLocation()
        motionManager?.stopAccelerometerUpdates()
        locationManager = nil
        motionManager = nil
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
        motionManager.accelerometerUpdateInterval = 0.5
        motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
            guard let acceleration = data?.acceleration else { return }
            self.acceleration = acceleration
            if acceleration.isGreater(than: self.maximumAcceleration) { self.maximumAcceleration = acceleration }
        }
        self.motionManager = motionManager
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
        guard let coordinate = manager.location?.coordinate, let speed = manager.location?.speed else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            withAnimation {
                userLocations.append(coordinate)
            }
            let convertedSpeed = speed.convertFromMsToKmh()
            currentSpeed = speed < 0 ? 0 : convertedSpeed
            if convertedSpeed > maximumSpeed { maximumSpeed = convertedSpeed }
        }
    }
}
