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
                            sessionDetailsView(session: session)
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
    
    private func sessionDetailsView(session: Session) -> some View {
        ZStack {
            Color(Theme.background)
            ZStack {
                VStack {
                    Text("\(session.maxSpeed)km/h")
                        .foregroundColor(.white)
                        .padding()
                    Text("\(session.maxGForce)G")
                        .foregroundColor(.white)
                        .padding()
                }
                .padding(.vertical, 120)
                .padding(.horizontal, 60)
            }
            .background(.ultraThinMaterial.opacity(0.5))
            .cornerRadius(24)
        }
        .ignoresSafeArea()
    }
}

// MARK: - Previews

struct PreviousView_Previews: PreviewProvider {
    static var previews: some View {
        SessionsView()
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
