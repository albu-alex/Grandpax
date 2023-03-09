//
//  ToastService.swift
//  Grandpax
//
//  Created by Alex Albu on 09.03.2023.
//

import UIKit

struct ToastService {
    
    static let shared = ToastService()

    func showToast(message: String, font: UIFont = UIFont.systemFont(ofSize: 14.0), bgColor: UIColor = UIColor.red.withAlphaComponent(0.6), textColor: UIColor = UIColor.white, duration: TimeInterval = 2.0) {
        
        let toastLabel = createToastLabel()
        toastLabel.text = message
        toastLabel.font = font
        toastLabel.backgroundColor = bgColor
        toastLabel.textColor = textColor
        
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            window.addSubview(toastLabel)

            NSLayoutConstraint.activate([
                toastLabel.topAnchor.constraint(equalTo: window.topAnchor, constant: 72),
                toastLabel.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 24),
                toastLabel.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -24)
            ])

            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                toastLabel.alpha = 1.0
            }, completion: { _ in
                UIView.animate(withDuration: duration, delay: 0.5, options: .curveEaseInOut, animations: {
                    toastLabel.alpha = 0.0
                }, completion: { _ in
                    toastLabel.removeFromSuperview()
                })
            })
        }
    }
    
    private func createToastLabel() -> UILabel {
        let toastLabel = UILabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.textAlignment = .center
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        return toastLabel
    }
    
}
