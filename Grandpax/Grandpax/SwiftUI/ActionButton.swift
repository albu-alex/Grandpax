//
//  ActionButton.swift
//  Grandpax
//
//  Created by Alex Albu on 05.11.2022.
//

import SwiftUI

import SwiftUI

struct ActionButton: View {
    private let image: Image
    private let action: () -> Void
    
    init(image: Image, action: @escaping () -> Void) {
        self.image = image
        self.action = action
    }
    
    // MARK: - Lifecycle

    var body: some View {
        Button(action: action) {
            image
        }
        .foregroundColor(AppDelegate.isDarkModeEnabled ? Color(Colors.white) : .black)
        .padding()
    }
}
