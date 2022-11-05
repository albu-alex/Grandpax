//
//  TrackView.swift
//  Grandpax
//
//  Created by Alex Albu on 05.11.2022.
//

import SwiftUI
import MapKit

struct TrackView: View {
    
    // MARK: - Environment
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - States
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 44.8683,
            longitude: 13.8481),
        span: MKCoordinateSpan(
            latitudeDelta: 0.03,
            longitudeDelta: 0.03)
    )
    @StateObject var locationManager = LocationManager()
    
    // MARK: - Properties
    
    private var currentLocation: CLLocation? {
        locationManager.lastLocation
    }
    private var userLatitude: Double {
        currentLocation?.coordinate.latitude ?? 0
    }
    private var userLongitude: Double {
        currentLocation?.coordinate.longitude ?? 0
    }
    
    // MARK: - Lifecycle
    
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                Spacer()
                ActionButton(image: Image(systemName: "xmark")) {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(.horizontal)
            }
            .frame(maxHeight: 60)
            .background(Color(Colors.white).opacity(0.5))
            .zIndex(8)
            Map(coordinateRegion: $region, showsUserLocation: true)
                .edgesIgnoringSafeArea(.bottom)
        }
        .shadow(color: Color(Colors.shadow) ,radius: 30, y: 25)
        .onChange(of: currentLocation) { newValue in
            region.center = CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude)
        }
    }
}

// MARK: - Preview

struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView()
    }
}
