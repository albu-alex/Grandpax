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
                        categoryView(description: metric, values: categoryValues(metric))
                    }
                }
                .padding(.bottom, 25)
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Properties
    
    private func categoryValues(_ category: String) -> [Double] {
        category == "Speed" ?
            previousSessions.map { $0.maxSpeed.convertFromMs() } :
            previousSessions.map { $0.maxGForce }
    }
    
    private func categoryView(description: String, values: [Double]) -> some View {
        return ZStack {
            VStack {
                Text(description)
                    .foregroundColor(.white)
                    .padding()
                barChartView(values: values)
            }
            .padding(.vertical, 40)
            .padding(.horizontal, 20)
        }
        .background(.ultraThinMaterial.opacity(0.5))
        .cornerRadius(24)
    }
    
    private func barChartView(values: [Double]) -> some View {
        let selectedBarColor = Color(Theme.accentBackground)
        let barColor = Color(Theme.accentColor)
        
        let selectedValue = values[selectedSessionIndex]
        let lowerValues = values.filter { $0 < selectedValue }.count
        
        return VStack(alignment: .leading, spacing: 10) {
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
