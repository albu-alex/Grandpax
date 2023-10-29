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
    private let ACCELERATION_UNIT = "G"
   
    private let otherSessions: [Session]
    private let session: Session
    
    // MARK: - Lifecycle
    
    init(otherSessions: [Session], session: Session) {
        self.otherSessions = otherSessions
        self.session = session
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color(Theme.background)
            VStack {
                HStack {
                    ActionButton(image: Image(systemName: "arrow.left")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                    Spacer()
                }
                Spacer()
                VStack {
                    CategoryComparisonView(
                        value: "\(String(session.maxSpeed).truncate(to: 6)) \(SPEED_UNIT)",
                        icon: Image(systemName: "speedometer"),
                        category: "Top Speed",
                        weakerSessionsCount: sessionsWeakerForCategory(SessionCategoryEnum.speed)
                    )
                    categorySeparator()
                    CategoryComparisonView(
                        value: "\(String(session.maxGForce).truncate(to: 6)) \(ACCELERATION_UNIT)",
                        icon: Image(systemName: "bolt.fill"),
                        category: "Max G-Force",
                        weakerSessionsCount: sessionsWeakerForCategory(SessionCategoryEnum.gForce)
                    )
                }
                .background(.ultraThinMaterial.opacity(0.5))
                .cornerRadius(24)
                .padding([.leading, .trailing, .bottom] ,48)
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Methods
    
    private func sessionsWeakerForCategory(_ category: SessionCategoryEnum) -> Int {
        let currentSessionValue = category == .speed ? session.maxSpeed : session.maxGForce
        let otherSessionsValues = category == .speed ? otherSessions.map { $0.maxSpeed } : otherSessions.map { $0.maxGForce }
        
        return otherSessionsValues.filter { $0 < currentSessionValue }.count
    }
    
    private func categorySeparator() -> some View {
        return VStack {
            Divider()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
    }
}

// MARK: - Helpers

fileprivate enum SessionCategoryEnum {
    case speed
    case gForce
}

fileprivate struct CategoryComparisonView: View {
    private let value: String
    private let icon: Image
    private let category: String
    private let weakerSessionsCount: Int
    
    init(value: String, icon: Image, category: String, weakerSessionsCount: Int) {
        self.value = value
        self.icon = icon
        self.category = category
        self.weakerSessionsCount = weakerSessionsCount
    }
    
    var body: some View {
        VStack(spacing: 32) {
            HStack(alignment: .center) {
                Spacer()
                VStack(spacing: 4) {
                    icon
                    Text(category)
                        .bold()
                }
                Spacer()
                Text(value)
                Spacer()
            }
            VStack(spacing: 4) {
                Text("Higher when compared to")
                Text("\(weakerSessionsCount) \(weakerSessionsCount == 1 ? "session" : "sessions")")
            }
        }
        .padding(.vertical, 32)
    }
}
