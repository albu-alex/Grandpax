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
    @StateObject private var trackViewModel = TrackViewModel()
    @StateObject private var mapViewModel = MapViewModel()
    @State private var trackingMode: MapUserTrackingMode = .follow
    @State private var isAlertPresented = false
    
    // MARK: - Lifecycle
    
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                Spacer()
                ActionButton(image: Image(systemName: "xmark")) {
                    isAlertPresented = true
                }
                .alert("Are you sure?", isPresented: $isAlertPresented, actions: {
                    Button("OK", role: .destructive) {
                        trackViewModel.deallocateManagers()
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Tracking is still in progress")
                }
                .padding(.horizontal)
            }
            .frame(maxHeight: 60)
            .background(Color(Colors.white).opacity(0.5))
            .zIndex(8)
            MapView(viewModel: mapViewModel)
                .edgesIgnoringSafeArea(.bottom)
                .tint(Color(Colors.strongGreen))
                .onAppear {
                    trackViewModel.startLocationsServices()
                    trackViewModel.startAccelerometer()
                }
                .onChange(of: trackViewModel.userLocations) { newValue in
                    mapViewModel.drawLine(newValue)
                    // Can force unwrap here because we only change center on last location change
                    mapViewModel.setCentralLocation(newValue.last!)
                }
            StatisticsView(
                currentAcceleration: $trackViewModel.acceleration,
                maximumAcceleration: $trackViewModel.maximumAcceleration,
                currentSpeed: $trackViewModel.currentSpeed,
                maximumSpeed: $trackViewModel.maximumSpeed
            )
            .offset(y: 550)
            .frame(maxHeight: 100)
        }
        .shadow(color: Color(Colors.shadow) ,radius: 30, y: 25)
    }
}

// MARK: - Preview

struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView()
    }
}
