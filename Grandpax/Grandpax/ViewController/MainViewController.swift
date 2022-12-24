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
        let settingsViewController = UIHostingController(rootView: SettingsView())
        present(settingsViewController, animated: true)
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.background
        
        setupTitleLabel()
        setupStartTrackingButton()
        setupStartTrackingLabel()
        setupPreviousButton()
        setupSettingsButton()
        setupButtonsStackView()
    }
    
    // MARK: - Private methods
    
    private func setupTitleLabel() {
        titleLabel.textColor = Theme.textColor
        titleLabel.text = CommonStrings.appName
        titleLabel.configureViewShadow(color: Colors.shadow, shadowRadius: 20)
    }
    
    private func setupStartTrackingButton() {
        startTrackingButton.tintColor = Theme.textColor
        startTrackingButton.configureViewShadow(color: Colors.shadow, offset: .init(width: 10, height: 10), shadowRadius: 15)
    }
    
    private func setupStartTrackingLabel() {
        startTrackingLabel.textColor = Theme.tintColor
        startTrackingLabel.configureViewShadow(color: Colors.shadow, opacity: 0.4, offset: .init(width: 5, height: 5))
    }
    
    private func setupPreviousButton() {
        previousButton.setTitleColor(Theme.textColor, for: .normal)
        previousButton.tintColor = Theme.textColor
    }
    
    private func setupSettingsButton() {
        settingsButton.setTitleColor(Theme.textColor, for: .normal)
        settingsButton.tintColor = Theme.textColor
    }
    
    private func setupButtonsStackView() {
        buttonsStackView.backgroundColor = Theme.accentBackground.withAlphaComponent(0.2)
        buttonsStackView.configureViewShadow(color: Colors.shadow, shadowRadius: 24)
        buttonsStackView.layer.cornerRadius = CornerRadius.Large
    }
}
