//
//  PreviousView.swift
//  Grandpax
//
//  Created by Alex Albu on 26.01.2023.
//

import SwiftUI
import Charts

//struct Session: Identifiable {
//    let id = UUID()
//    let sessionName: String
//    let maxGForce: Double
//    let maxSpeed: Double
//}

struct SessionData: Identifiable {
    let id = UUID()
    let name: String
    let value: Double
}

struct PreviousView: View {
    
    // MARK: - Properties
    
    private var previousSessions = [SessionData]()
    
    // MARK: - Environment
    
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - States
    
    @State private var isAlertPresented = false
    
    // MARK: - Lifecycle
    
    init() {
        previousSessions = [
            SessionData(name: "Test", value: 5),
            SessionData(name: "Another", value: 48)
        ]
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                Text("Statistics")
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
            .zIndex(2)
            NavigationView {
                List(previousSessions) { session in
                    NavigationLink {
                        Text("\(session.value)")
                    } label: {
                        Text(session.name)
                            .foregroundColor(Color(Theme.textColor))
                    }
                    .listRowBackground(Color(Theme.accentBackground))
                    .listRowSeparatorTint(Color(Theme.textColor))
                }
                .background(Color(Theme.background))
                .scrollContentBackground(.hidden)
            }
            .toolbar(.hidden)
            .padding(.top, 60)
        }
    }
}

// MARK: - Previews

struct PreviousView_Previews: PreviewProvider {
    static var previews: some View {
        PreviousView()
    }
}


//var body: some View {
//    VStack {
//        GroupBox("Stats from previous sessions") {
//            Chart(previousSessions, id: \.name) { session in
//                BarMark(
//                    x: .value("Session", session.name),
//                    y: .value("Top Speed", session.value)
//                )
//            }
//            .chartYAxis {
//                AxisMarks(position: .leading)
//            }
//            .chartForegroundStyleScale([
//                "Max G-Force" : Color(hue: 0.10, saturation: 0.70, brightness: 0.90),
//                "Top Speed": Color(hue: 0.80, saturation: 0.70, brightness: 0.80)
//            ])
//        }
//        .frame(height: 500)
//        Spacer()
//    }
//    .padding()
//}
