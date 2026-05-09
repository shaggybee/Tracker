//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Kislov Vadim on 02.05.2026.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Private properties
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var selectedDate: Date = Date()
    
    private lazy var addTrackerButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(resource: .plus), for: .normal)
        button.tintColor = .ypBlack
        button.addTarget(self, action:  #selector(didTapAddTracker(_:)), for: .touchUpInside)
        
        return button
    }().forAutoLayout
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(didChangeDate(_:)), for: .valueChanged)
        
        return datePicker
    }().forAutoLayout
    
    private lazy var titleLable: UILabel = {
        let label = UILabel()
        
        label.font = Font.bold34
        label.textColor = .ypBlack
        label.text = Constants.titleText
        
        return label
    }().forAutoLayout
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "Поиск"
        
        return textField
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
        
        configNavigationItems()

        view.addSubview(titleLable)
        view.addSubview(searchTextField)
        view.addSubview(emptyStateView)
        
        setupConstraints()
    }
    
    private func configNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addTrackerButton)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        if #available(iOS 26.0, *) {
            navigationItem.rightBarButtonItem?.hidesSharedBackground = true
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Spacing.separator),
            titleLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Spacing.space16),
            
            searchTextField.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: Spacing.space8),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space16),
            
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space16),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space16),
            emptyStateView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    @objc private func didChangeDate(_ sender: UIDatePicker) {
        selectedDate = sender.date
    }
    
    @objc private func didTapAddTracker(_ sender: UIButton) {
        let trackerTypeSelectionVC = TrackerTypeSelectionViewController()
        
        trackerTypeSelectionVC.delegate = self
        present(trackerTypeSelectionVC, animated: true)
    }
}

// MARK: - TrackerTypeSelectionViewControllerDelegate
extension TrackersViewController: TrackerTypeSelectionViewControllerDelegate {
    func trackerTypeSelectionViewController(_ vc: TrackerTypeSelectionViewController, didSelect type: TrackerType) {
        vc.dismiss(animated: true)
        
        let trackerFormVC = TrackerFormViewController()
        let presenter = TrackerFormViewPresenter(trackerType: type)
        presenter.view = trackerFormVC
        trackerFormVC.delegate = self
        trackerFormVC.presenter = presenter
        
        present(trackerFormVC, animated: true)
    }
}

// MARK: - TrackerFormViewControllerDelegate
extension TrackersViewController: TrackerFormViewControllerDelegate {
    func trackerFormViewController(_ vc: TrackerFormViewController, didCreateTracker tracker: Tracker) {
        
    }
}

// MARK: - Constants
private extension TrackersViewController {
    enum Constants {
        static let titleText = "Трекеры"
        static let emptyStateText = "Что будем отслеживать?"
    }
}
