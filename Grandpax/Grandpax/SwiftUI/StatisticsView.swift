//
//  StatisticsView.swift
//  Grandpax
//
//  Created by Alex Albu on 05.11.2022.
//

import SwiftUI

struct StatisticsView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Current speed")
                    .bold()
                Text("4 KM/H")
            }
            .padding(.horizontal, 32)
            .padding(.top)
            Spacer()
            HStack {
                Text("Max speed")
                    .bold()
                Text("20 KM/H")
            }
            .padding(.horizontal, 32)
            .padding(.top)
            Spacer()
            HStack {
                Text("Current G-Force")
                    .bold()
                Text("0.8 G")
            }
            .padding(.horizontal, 32)
            .padding(.vertical)
            Spacer()
            HStack {
                Text("Max G-Force")
                    .bold()
                Text("2 G")
            }
            .padding(.horizontal, 32)
            .padding(.bottom)
        }
        .background(Color(Colors.white).opacity(0.9))
        .cornerRadius(20)
        .padding(.vertical, 400)
        .shadow(color: Color(Colors.shadow), radius: 5)
    }
}

// MARK: - Extensions

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
