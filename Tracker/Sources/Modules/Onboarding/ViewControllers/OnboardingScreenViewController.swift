//
//  OnboardingScreenViewController.swift
//  Tracker
//
//  Created by Kislov Vadim on 03.06.2026.
//

import UIKit

final class OnboardingScreenViewController: UIViewController {
    
    // MARK: - Private properties
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        
        label.font = Font.bold32
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }().forAutoLayout
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        
        return image
    }().forAutoLayout
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElements()
    }
    
    // MARK: - Public methods
    func config(with model: OnboardingScreenModel) {
        infoLabel.text = model.text
        backgroundImage.image = model.image
    }
    
    // MARK: - Private methods
    private func setElements() {
        view.backgroundColor = .ypWhite
        
        view.addSubview(backgroundImage)
        view.addSubview(infoLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space16),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space16)
        ])
    }
}
