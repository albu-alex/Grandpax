//
//  TrackView.swift
//  Grandpax
//
//  Created by Alex Albu on 05.11.2022.
//

import SwiftUI
import CoreLocationUI
import MapKit

struct TrackView: View {
    
    // MARK: - Properties
    
    private var isCenteringLocation: Bool {
        trackViewModel.isCenteringLocation
    }
    
    // MARK: - Environment
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - States
    @StateObject private var trackViewModel = TrackViewModel()
    @StateObject private var mapViewModel = MapViewModel()
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
            HStack {
                Spacer()
                VStack {
                    LocationButton(.currentLocation, action: {
                        trackViewModel.isCenteringLocation.toggle()
                    })
                    .tint(Color(Colors.white))
                    .foregroundColor(Color(Theme.tintColor))
                    .labelStyle(.iconOnly)
                    .symbolVariant(isCenteringLocation ? .fill : .none)
                    .cornerRadius(8)
                }
            }
            .frame(height: AppDelegate.screenBounds.height / 2, alignment: .center)
            .padding()
            .zIndex(8)
            MapView(viewModel: mapViewModel)
                .edgesIgnoringSafeArea(.bottom)
                .tint(Color(Theme.tintColor))
                .onAppear {
                    trackViewModel.startLocationsServices()
                    trackViewModel.startAccelerometer()
                }
                .onChange(of: trackViewModel.userLocations) { newValue in
                    mapViewModel.drawLine(newValue)
                }
                .gesture(
                    MagnificationGesture()
                        .onChanged { _ in
                            trackViewModel.isCenteringLocation = false
                        }
                )
                .onTapGesture {
                    trackViewModel.isCenteringLocation = false
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
