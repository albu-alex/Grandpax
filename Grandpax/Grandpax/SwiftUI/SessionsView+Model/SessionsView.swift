//
//  SessionsView.swift
//  Grandpax
//
//  Created by Alex Albu on 26.01.2023.
//

import SwiftUI
import Charts
import RealmSwift

struct SessionsView: View {
    
    // MARK: - Environment
    
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - States
    
    @State private var isAlertPresented = false
    @StateObject var viewModel = SessionsViewModel()
    
    // MARK: - Properties
    
    private var headerText: Text {
        let sessionsCount = viewModel.sessions.count
        let timesString = sessionsCount == 1 ? "time" : "times"
        return Text("You have raced \(sessionsCount) \(timesString)")
            .bold()
    }
    
    // MARK: - Lifecycle
    
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                Text("Statistics")
                    .bold()
                    .font(.system(size: 22))
                Spacer()
                ActionButton(image: Image(systemName: "xmark")) {
                    presentationMode.wrappedValue.dismiss()
                    viewModel.hardRemoveSessions()
                }
            }
            .padding(.horizontal, 16)
            .frame(maxHeight: 60)
            .background(Color(Colors.white).opacity(0.5))
            .shadow(color: Color(Colors.shadow), radius: 40, y: 25)
            .zIndex(2)
            Color(Theme.background)
            VStack(alignment: .leading) {
                HStack {
                    headerText
                }
                .padding(.top, 80)
                .padding(.horizontal, 24)
                NavigationView {
                    List(viewModel.sessions) { session in
                        NavigationLink {
                            SessionDetailsView(previousSessions: viewModel.sessions, session: session)
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            Text(session.name)
                                .foregroundColor(Color(Theme.textColor))
                                .padding(.vertical, 16)
                        }
                        .listRowBackground(Color(Theme.accentBackground))
                        .listRowSeparatorTint(Color(Theme.textColor))
                        .swipeActions {
                            Button(action: {
                                viewModel.softRemoveSession(session)
                            }, label: {
                                Image(systemName: "trash")
                            })
                            .tint(.red)
                        }
                    }
                    .background(Color(Theme.background))
                    .scrollContentBackground(.hidden)
                }
                .toolbar(.hidden)
            }
        }
    }
}

fileprivate struct SessionDetailsView: View {
    
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
        
        let minValue = (values.min() ?? 0) * 0.9
        let maxValue = (values.max() ?? 0) * 1.1
        
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
//            .chartYScale(domain: minValue...maxValue)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(width: 300, height: 200)
        }
    }
}

// MARK: - Previews

struct PreviousView_Previews: PreviewProvider {
    static var previews: some View {
        SessionsView()
    }
}
