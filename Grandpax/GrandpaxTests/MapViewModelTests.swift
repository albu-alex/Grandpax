//
//  MapViewModelTests.swift
//  GrandpaxTests
//
//  Created by Alex Albu on 18.06.2023.
//

import XCTest
import CoreLocation
import MapKit

@testable import Grandpax

class MapViewModelTests: XCTestCase {
    
    var viewModel: MapViewModel!
    var mapView: MKMapView!
    
    override func setUp() {
        super.setUp()
        viewModel = MapViewModel()
        mapView = MKMapView()
        viewModel.injectMapView(mapView)
    }
    
    override func tearDown() {
        viewModel = nil
        mapView = nil
        super.tearDown()
    }
    
    func testDrawLine() {
        // Add coordinates
        let coordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)
        ]
        viewModel.locations = coordinates
        viewModel.drawLine(coordinates)
        
        // Verify that the locations array is updated
        XCTAssertEqual(viewModel.locations.count, coordinates.count)
        XCTAssertEqual(viewModel.locations.first, coordinates.first)
        XCTAssertEqual(viewModel.locations.last, coordinates.last)
        
        // Verify that the polyline is added to the map view
        XCTAssertEqual(mapView.overlays.count, 1)
        XCTAssertTrue(mapView.overlays.first is MKPolyline)
        
        // Verify that the user tracking mode is set
        XCTAssertEqual(mapView.userTrackingMode, .follow)
    }
}

