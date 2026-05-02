//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Kislov Vadim on 02.05.2026.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Private properties
    private lazy var titleLable: UILabel = {
        let label = UILabel()
        
        label.font = Font.bold34
        label.textColor = .ypBlack
        label.text = Constants.titleText
        
        return label
    }().forAutoLayout
    
    private lazy var emptyStateView: EmptyStateView = {
        let emptyStateView = EmptyStateView(text: Constants.emptyStateText)
        
        return emptyStateView
    }().forAutoLayout
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElements()
    }
    
    // MARK: - Private methods
    private func setElements() {
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(resource: .plus),
            style: .plain,
            target: self,
            action: nil)
        navigationItem.leftBarButtonItem?.tintColor = .ypBlack

        view.addSubview(titleLable)
        view.addSubview(emptyStateView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Spacing.separator),
            titleLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Spacing.md),
            
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.md),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.md),
            emptyStateView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
}

private extension TrackersViewController {
    enum Constants {
        static let titleText = "Статистика"
        static let emptyStateText = "Что будем отслеживать?"
    }
}
