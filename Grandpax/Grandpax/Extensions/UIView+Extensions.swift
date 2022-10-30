//
//  UIView+Extensions.swift
//  Grandpax
//
//  Created by Alex Albu on 30.10.2022.
//

import UIKit

extension UIView {
    func configureViewShadow(color: UIColor = .black, opacity: Float = 0.6, offset: CGSize = .zero, shadowRadius: CGFloat = 10) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = shadowRadius
    }
}
