//
//  MainViewController.swift
//  Grandpax
//
//  Created by Alex Albu on 29.10.2022.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startTrackingLabel: UILabel!
    @IBOutlet weak var startTrackingButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func onStartTrackingButtonPressed(_ sender: Any) {
        let trackViewController = UIHostingController(rootView: TrackView())
        present(trackViewController, animated: true)
    }
    @IBAction func onPreviousButtonPressed(_ sender: Any) {
        print(#function)
    }
    @IBAction func onSettingsButtonPressed(_ sender: Any) {
        print(#function)
    }
    
    // MARK: - Public properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.strongGreen
        
        setupTitleLabel()
        setupStartTrackingButton()
        setupStartTrackingLabel()
        setupPreviousButton()
        setupSettingsButton()
        setupButtonsStackView()
    }
    
    // MARK: - Private methods
    
    private func setupTitleLabel() {
        titleLabel.textColor = Colors.white
        titleLabel.configureViewShadow(color: Colors.shadow, shadowRadius: 20)
    }
    
    private func setupStartTrackingButton() {
        startTrackingButton.tintColor = Colors.white
        startTrackingButton.configureViewShadow(color: Colors.shadow, offset: .init(width: 10, height: 10), shadowRadius: 15)
    }
    
    private func setupStartTrackingLabel() {
        startTrackingLabel.textColor = Colors.mediumLightGreen
        startTrackingLabel.configureViewShadow(color: Colors.shadow, opacity: 0.4, offset: .init(width: 5, height: 5))
    }
    
    private func setupPreviousButton() {
        previousButton.setTitleColor(Colors.white, for: .normal)
        previousButton.tintColor = Colors.white
    }
    
    private func setupSettingsButton() {
        settingsButton.setTitleColor(Colors.white, for: .normal)
        settingsButton.tintColor = Colors.white
    }
    
    private func setupButtonsStackView() {
        buttonsStackView.backgroundColor = Colors.mediumStrongGreen.withAlphaComponent(0.2)
        buttonsStackView.configureViewShadow(color: Colors.shadow, shadowRadius: 24)
        buttonsStackView.layer.cornerRadius = CornerRadius.Large
    }
}
