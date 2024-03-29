//
//  MapView.swift
//  Grandpax
//
//  Created by Alex Albu on 30.11.2022.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    // MARK: - Properties
    
    private let CoordinateDistance = 1000.0
    
    // MARK: - StateObject
    
    @StateObject var viewModel: MapViewModel

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.isRotateEnabled = false
        mapView.isZoomEnabled = false
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(minCenterCoordinateDistance: CoordinateDistance, maxCenterCoordinateDistance: CoordinateDistance), animated: true)
        viewModel.injectMapView(mapView)
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) { }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        private var renderer = MKPolylineRenderer()
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let polyline = overlay as? MKPolyline else { return MKOverlayRenderer() }
            renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = Theme.tintColor
            renderer.lineWidth = 3.0
            return renderer
        }
    }
}
