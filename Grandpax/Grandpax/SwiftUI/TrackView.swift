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
    @StateObject private var viewModel = TrackViewModel()
    @State private var trackingMode: MapUserTrackingMode = .follow
    
    // MARK: - Lifecycle
    
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                Spacer()
                ActionButton(image: Image(systemName: "xmark")) {
                    viewModel.deallocateManagers()
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(.horizontal)
            }
            .frame(maxHeight: 60)
            .background(Color(Colors.white).opacity(0.5))
            .zIndex(8)
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, userTrackingMode: $trackingMode)
                .edgesIgnoringSafeArea(.bottom)
                .tint(Color(Colors.strongGreen))
                .onAppear {
                    viewModel.startLocationsServices()
                    viewModel.startAccelerometer()
                }
            StatisticsView(
                currentAcceleration: $viewModel.acceleration,
                maximumAcceleration: $viewModel.maximumAcceleration,
                currentSpeed: $viewModel.currentSpeed,
                maximumSpeed: $viewModel.maximumSpeed
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
