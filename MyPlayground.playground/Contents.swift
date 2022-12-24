//
//  OutcropCalloutView.swift
//  Discover
//
//  Created by Alex Albu on 12.12.2022.
//  Copyright © 2022 Yonder. All rights reserved.
//

import SwiftUI
import Foundation
import PlaygroundSupport

private struct CalloutShape: Shape {
    private let arrowHeight: CGFloat = 10
    private let radius: CGFloat = 8
    
    func path(in rect: CGRect) -> SwiftUI.Path {
        let path = UIBezierPath()
        path.move(to: .init(x: rect.midX, y: rect.maxY + arrowHeight))
        path.addLine(to: .init(x: rect.midX - 3 / 4 * arrowHeight, y: rect.maxY))
        path.addLine(to: .init(x: rect.minX + radius, y: rect.maxY))
        path.addArc(withCenter: .init(x: rect.minX + radius, y: rect.maxY - radius), radius: radius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
        path.addLine(to: .init(x: rect.minX, y: rect.minY + radius))
        path.addArc(withCenter: .init(x: rect.minX + radius, y: rect.minY + radius), radius: radius, startAngle: .pi, endAngle: 3 / 2 * .pi, clockwise: true)
        path.addLine(to: .init(x: rect.maxX - radius, y: rect.minY))
        path.addArc(withCenter: .init(x: rect.maxX - radius, y: rect.minY + radius), radius: radius, startAngle: 3 / 2 * .pi, endAngle: 0, clockwise: true)
        path.addLine(to: .init(x: rect.maxX, y: rect.maxY - radius))
        path.addArc(withCenter: .init(x: rect.maxX - radius, y: rect.maxY - radius), radius: radius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
        path.addLine(to: .init(x: rect.midX + 3 / 4 * arrowHeight, y: rect.maxY))
        path.close()
        
        path.stroke()

        return SwiftUI.Path(path.cgPath)
    }
}

struct OutcropCalloutView: View {
    
    // MARK: - Properties
    
    let labelText: String
    
    // MARK: - Body
    
    var body: some View {
        Text(labelText)
            .font(.system(.caption, design: .rounded))
            .foregroundColor(.black)
            .padding(8)
            .background(
                CalloutShape()
                    .fill(.white)
            )
            .padding(.bottom, 10)
    }
}

let calloutView = OutcropCalloutView(labelText: "Test is very long hdsajdasdas")
let hostingController = UIHostingController(rootView: calloutView)
hostingController.view.backgroundColor = .black
hostingController.view.setNeedsDisplay()
print(hostingController.view.intrinsicContentSize)
print(hostingController.view)
PlaygroundPage.current.liveView = hostingController
print(hostingController.view)
