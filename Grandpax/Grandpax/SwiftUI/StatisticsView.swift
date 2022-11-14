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
    
    @State private var isPresentingAlert = false
    
    // MARK: - Properties
    
    private var accelerationCurrent: Double {
        abs(currentAcceleration.x) +
        abs(currentAcceleration.y) +
        abs(currentAcceleration.z)
    }
    
    private var accelerationMax: Double {
        abs(maximumAcceleration.x) +
        abs(maximumAcceleration.y) +
        abs(maximumAcceleration.z)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Current speed")
                    .bold()
                Text(String(format: "%.2f", currentSpeed) + " km/h")
            }
            .foregroundColor(.black)
            .padding(.horizontal, 32)
            .padding(.top)
            Spacer()
            HStack {
                Text("Top speed")
                    .bold()
                Text(String(format: "%.2f", maximumSpeed) + " km/h")
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
                if newValue > 7 {
                    isPresentingAlert = true
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
        .padding(.vertical, 400)
        .shadow(color: Color(Colors.shadow), radius: 5)
        .alert("Unusual G-Force reading", isPresented: $isPresentingAlert, actions: {}) {
            Text("For accurate results, hold the phone standstill")
        }
    }
}

// MARK: - Extensions

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(
            currentAcceleration: .constant(CMAcceleration()),
            maximumAcceleration: .constant(CMAcceleration()),
            currentSpeed: .constant(1),
            maximumSpeed: .constant(10))
    }
}
