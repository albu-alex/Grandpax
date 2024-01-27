//
//  StatisticsView.swift
//  Grandpax
//
//  Created by Alex Albu on 05.11.2022.
//

import SwiftUI
import CoreMotion

struct StatisticsView: View {
    
    // MARK: - Bindings
    
    @Binding var currentAcceleration: CMAcceleration
    @Binding var maximumAcceleration: CMAcceleration
    @Binding var currentSpeed: Double
    @Binding var maximumSpeed: Double
    
    // MARK: - States
    
    @State private var isPresentingCautionAlert = false
    @State private var isPresentingDangerAlert = false
    
    // MARK: - Properties
    
    private let G_FORCE_TRESHOLD = 4.0
    private let DANGER_G_FORCE_TRESHOLD = 8.0
    private let SPEED_UNIT = UserDefaultsManager.Settings.isImperialUnitsSelected ? "mph" : "km/h"
    
    private var accelerationCurrent: Double {
        currentAcceleration.acceleration
    }
    private var accelerationMax: Double {
        maximumAcceleration.acceleration
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Current speed")
                    .bold()
                Text(String(format: "%.2f", currentSpeed.convertFromMs()) + SPEED_UNIT)
            }
            .foregroundColor(.black)
            .padding(.horizontal, 32)
            .padding(.top)
            Spacer()
            HStack {
                Text("Top speed")
                    .bold()
                Text(String(format: "%.2f", maximumSpeed.convertFromMs()) + SPEED_UNIT)
            }
            .foregroundColor(.black)
            .padding(.horizontal, 32)
            .padding(.top)
            Spacer()
            HStack {
                Text("Current G-Force")
                    .bold()
                Text(String(format: "%.2f", accelerationCurrent) + " G")
            }
            .foregroundColor(.black)
            .padding(.horizontal, 32)
            .padding(.vertical)
            .onChange(of: accelerationCurrent) { newValue in
                if newValue > DANGER_G_FORCE_TRESHOLD {
                    isPresentingDangerAlert = true
                } else if newValue > G_FORCE_TRESHOLD {
                    isPresentingCautionAlert = true
                }
            }
            Spacer()
            HStack {
                Text("Max G-Force")
                    .bold()
                Text(String(format: "%.2f", accelerationMax) + " G")
            }
            .foregroundColor(.black)
            .padding(.horizontal, 32)
            .padding(.bottom)
        }
        .background(Color(Colors.white).opacity(0.9))
        .cornerRadius(20)
        .fixedSize(horizontal: true, vertical: true)
        .shadow(color: Color(Colors.shadow), radius: 5)
        .alert("Unusual G-Force reading", isPresented: $isPresentingCautionAlert, actions: {}) {
            Text("The reading of \(accelerationCurrent) G is equivalent to a small crash. Drive more carefully.")
        }
        .alert("Unusual G-Force reading", isPresented: $isPresentingDangerAlert, actions: {
            Button("Yes") {
                callEmergencyNumber()
            }
            Button("No") {
                isPresentingDangerAlert = false
            }
        }) {
            Text("The reading of \(accelerationCurrent) G is equivalent to a big crash. Do you want to call the emergency number?")
        }
    }
    
    private func callEmergencyNumber() {
        
    }
}

// MARK: - Previews

#Preview {
    StatisticsView(
        currentAcceleration: .constant(CMAcceleration()),
        maximumAcceleration: .constant(CMAcceleration()),
        currentSpeed: .constant(1),
        maximumSpeed: .constant(10))
}
