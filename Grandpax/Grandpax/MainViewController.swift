//
//  MainViewController.swift
//  Grandpax
//
//  Created by Alex Albu on 29.10.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.strongGreen
        titleLabel.textColor = Colors.white
    }
}

