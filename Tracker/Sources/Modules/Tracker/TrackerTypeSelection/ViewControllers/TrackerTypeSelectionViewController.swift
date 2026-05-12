//
//  TrackerTypeSelectionViewController.swift
//  Tracker
//
//  Created by Kislov Vadim on 05.05.2026.
//

import UIKit

final class TrackerTypeSelectionViewController: UIViewController {
    
    // MARK: - Public properties
    weak var delegate: TrackerTypeSelectionViewControllerDelegate?
    
    // MARK: - Private properties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = Font.medium16
        label.text = Constants.title
        
        return label
    }().forAutoLayout
    
    lazy var addHabitButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(Constants.addHabitButtonText, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = Radius.size16
        button.addTarget(
            self,
            action: #selector(didTapAddHabitButton(_:)),
            for: .touchUpInside)
        
        return button
    }().forAutoLayout
    
    lazy var addIrregularEventButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(Constants.addIrregularEventButtonText, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = Radius.size16
        button.addTarget(
            self,
            action: #selector(didTapAddIrregularEventButton(_:)),
            for: .touchUpInside)
        
        return button
    }().forAutoLayout
    
    lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        
        stack.spacing = Spacing.space16
        stack.axis = .vertical
        
        return stack
    }().forAutoLayout
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElements()
    }
    
    // MARK: - Private methods
    private func setElements() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(buttonsStack)
        
        buttonsStack.addArrangedSubview(addHabitButton)
        buttonsStack.addArrangedSubview(addIrregularEventButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Spacing.space28),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addHabitButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            addIrregularEventButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            
            buttonsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space20)
        ])
    }
    
    @objc private func didTapAddHabitButton(_ sender: UIButton) {
        delegate?.trackerTypeSelectionViewController(self, didSelect: .habit)
    }
    
    @objc private func didTapAddIrregularEventButton(_ sender: UIButton) {
        delegate?.trackerTypeSelectionViewController(self, didSelect: .irregularEvent)
    }
}

// MARK: - Constants
private extension TrackerTypeSelectionViewController {
    enum Constants {
        static let buttonHeight: CGFloat = 60
        
        static let title = "Создание трекера"
        static let addHabitButtonText = "Привычка"
        static let addIrregularEventButtonText = "Нерегулярное событие"
    }
}
