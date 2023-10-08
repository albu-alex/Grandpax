//
//  SessionDetailsView.swift
//  Grandpax
//
//  Created by Alex Albu on 07.10.2023.
//

import SwiftUI
import Charts

struct SessionDetailsView: View {
    
    // MARK: - Environment
    
    @Environment(\.presentationMode) private var presentationMode
    
    // MARK: - Properties
    
    private let SPEED_UNIT = UserDefaultsManager.Settings.isImperialUnitsSelected ? "mph" : "km/h"
   
    private let previousSessions: [Session]
    private let session: Session
    private let selectedSessionIndex: Int
    private let sessionMetrics: [String]
    
    // MARK: - Lifecycle
    
    init(previousSessions: [Session], session: Session) {
        self.previousSessions = previousSessions
        self.session = session
        
        selectedSessionIndex = previousSessions.firstIndex(of: session) ?? 0
        sessionMetrics = ["Speed", "G-Force"]
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color(Theme.background)
            ScrollView {
                HStack {
                    ActionButton(image: Image(systemName: "arrow.left")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                    Spacer()
                }
                VStack {
                    ForEach(sessionMetrics, id: \.self) { metric in
                        CategoryView(description: metric, values: categoryValues(metric), selectedSessionIndex: selectedSessionIndex)
                    }
                }
                .padding(.bottom, 25)
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Methods
    
    private func categoryValues(_ category: String) -> [Double] {
        category == "Speed" ?
            previousSessions.map { $0.maxSpeed.convertFromMs() } :
            previousSessions.map { $0.maxGForce }
    }
}

// MARK: - Helper Views

fileprivate struct CategoryView: View {
    
    // MARK: - Properties
    
    let description: String
    let values: [Double]
    let selectedSessionIndex: Int
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            VStack {
                Text(description)
                    .foregroundColor(.white)
                    .padding()
                BarChartView(values: values, selectedSessionIndex: selectedSessionIndex)
            }
            .padding(.vertical, 40)
            .padding(.horizontal, 20)
        }
        .background(.ultraThinMaterial.opacity(0.5))
        .cornerRadius(24)
    }
}

fileprivate struct BarChartView: View {
    
    // MARK: - Properties
    
    private let values: [Double]
    private let selectedSessionIndex: Int
    
    private var selectedBarColor: Color
    private var barColor: Color
    private var selectedValue: Double
    private var lowerValues = 0
    
    // MARK: - Lifecycle
    
    init(values: [Double], selectedSessionIndex: Int) {
        self.values = values
        self.selectedSessionIndex = selectedSessionIndex
        
        selectedBarColor = Color(Theme.accentBackground)
        barColor = Color(Theme.accentColor)
        selectedValue = values[selectedSessionIndex]
        lowerValues = values.filter { $0 < selectedValue }.count
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Higher stat compared to \(lowerValues) sessions!")
                .font(.caption)
            
            Chart(values, id: \.self) { value in
                BarMark(
                    x: .value("\(values.firstIndex(of: value)!)", values.firstIndex(of: value)!),
                    y: .value("\(value)", value)
                )
                .foregroundStyle(selectedSessionIndex == values.firstIndex(of: value)! ? selectedBarColor : barColor)
                .cornerRadius(4)
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(width: 300, height: 200)
        }
    }
}
