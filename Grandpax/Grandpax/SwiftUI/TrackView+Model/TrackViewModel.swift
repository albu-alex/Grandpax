//
//  TrackViewModel.swift
//  Grandpax
//
//  Created by Alex Albu on 05.11.2022.
//

import SwiftUI
import MapKit
import CoreMotion

final class TrackViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    var locationManager: CLLocationManager?
    var motionManager: CMMotionManager?
    var userLocations = [CLLocationCoordinate2D]()
    var averageSpeed: Double = 0
    var averageAcceleration: Double = 0
    
    private var speedReadings = [Double]() {
        didSet {
            averageSpeed = speedReadings.isEmpty ? .zero : speedReadings.reduce(.zero) { $0 + $1 } / Double(speedReadings.count)
        }
    }
    private var accelerationReadings = [CMAcceleration]() {
        didSet {
            averageAcceleration = accelerationReadings.isEmpty ? .zero : accelerationReadings.sum() / Double(accelerationReadings.count)
        }
    }
    
    // MARK: - States
    
    @Published var currentAcceleration = CMAcceleration()
    @Published var maximumAcceleration = CMAcceleration()
    @Published var currentSpeed = CLLocationSpeed()
    @Published var maximumSpeed = CLLocationSpeed()
    @Published var isCenteringLocation = UserDefaultsManager.Settings.isFollowingCurrentLocation {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("LocationCenteringDidChange"), object: nil, userInfo: ["isCenteringLocation":  isCenteringLocation])
        }
    }
    
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
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
            guard let self, let acceleration = data?.acceleration else { return }
            self.accelerationReadings.append(acceleration)
            self.currentAcceleration = acceleration
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
            ToastService.shared.showToast(message: "Location is restricted", type: .info)
        case .denied:
            ToastService.shared.showToast(message: "Location is denied", type: .info)
        default:
            break
        }
    }
}

// MARK: - Extensions

extension TrackViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            checkLocationAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = manager.location?.coordinate, let speed = manager.location?.speed else { return }
        DispatchQueue.main.async { [self] in
            userLocations.append(coordinate)
            speedReadings.append(speed)
            currentSpeed = speed
            if speed > maximumSpeed { maximumSpeed = speed }
        }
    }
}
