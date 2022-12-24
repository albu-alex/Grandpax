//
//  SettingsView.swift
//  Grandpax
//
//  Created by Alex Albu on 01.12.2022.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - Environment
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - States
    @StateObject private var viewModel = SettingsViewModel()
    
    // MARK: - Properties
    
    private let toggleColor = Theme.tintColor
    private let backgroundColor = Theme.background
    
    // MARK: - Lifecycle
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Settings")
                    .bold()
                    .font(.system(size: 22))
                Spacer()
                ActionButton(image: Image(systemName: "xmark")) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding(.horizontal, 16)
            .frame(maxHeight: 60)
            .background(Color(Colors.white).opacity(0.5))
            .shadow(color: Color(Colors.shadow), radius: 40, y: 25)
            .padding(.bottom, 72)
            VStack(spacing: 24) {
                Toggle("Imperial units", isOn: $viewModel.isImperialUnitsSelected)
                Toggle("Save tracking data", isOn: $viewModel.isSavingTrackingData)
                Toggle("Follow current location", isOn: $viewModel.isFollowingCurrentLocation)
                Spacer()
            }
            .tint(Color(toggleColor))
            .padding(.horizontal, 24)
        }
        .background(Color(backgroundColor))
    }
}

// MARK: - Extensions

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
