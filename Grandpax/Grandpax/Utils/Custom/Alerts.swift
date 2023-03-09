//
//  Alerts.swift
//  Grandpax
//
//  Created by Alex Albu on 14.11.2022.
//

import UIKit

struct Alerts {
    static func presentAlertWithActions(viewController: UIViewController, title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
