//
//  TrackerFormViewController.swift
//  Tracker
//
//  Created by Kislov Vadim on 05.05.2026.
//

import UIKit

final class TrackerFormViewController: UIViewController, TrackerFormViewControllerProtocol {
    
    // MARK: - Public properties
    weak var delegate: TrackerFormViewControllerDelegate?
    
    var presenter: TrackerFormViewPresenterProtocol?
    
    // MARK: - Private properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = Font.medium16
        
        return label
    }().forAutoLayout
    
    private lazy var contentScrollView: UIScrollView = UIScrollView().forAutoLayout
    
    private lazy var nameInputField: InputFieldView = {
        let inputFieldView = InputFieldView(placeholder: Constants.nameFieldPlaceholder)
        
        return inputFieldView
    }().forAutoLayout
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(Constants.submitButtonText, for: .normal)
        button.backgroundColor = .ypGray
        button.isEnabled = false
        button.layer.cornerRadius = Radius.size16
        button.addTarget(
            self,
            action: #selector(didTapSubmitButton(_:)),
            for: .touchUpInside)
        
        return button
    }().forAutoLayout
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(Constants.cancelButtonText, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = Radius.size16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.setTitleColor(.red, for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapCancelButton(_:)),
            for: .touchUpInside)
        
        return button
    }().forAutoLayout
    
    private lazy var footerButtonsStackView: UIStackView = {
        let stack = UIStackView()
        
        stack.spacing = Spacing.space8
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        return stack
    }().forAutoLayout
    
    private lazy var trackerOptionsView: TrackerOptionsView = {
        let trackerOptionsView = TrackerOptionsView(trackerOptions: presenter?.trackerOptions ?? [])
        
        return trackerOptionsView
    }().forAutoLayout
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        setElements()
    }
    
    // MARK: - Public methods
    func setSubmitButtonEnabled(_ isEnabled: Bool) {
        if submitButton.isEnabled == isEnabled { return }
        
        submitButton.isEnabled = isEnabled
        
        if (isEnabled) {
            submitButton.backgroundColor = .ypBlack
        } else {
            submitButton.backgroundColor = .ypGray
        }
    }
    
    func setTrackerNameFieldError(_ error: String?) {
        nameInputField.setError(error)
    }
    
    func setDescription(for trackerOption: TrackerOptionType, with text: String) {
        trackerOptionsView.setDescription(for: trackerOption, with: text)
    }
    
    // MARK: - Private methods
    private func setElements() {
        trackerOptionsView.delegate = self
        nameInputField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        view.backgroundColor = .white
        
        titleLabel.text = presenter?.trackerFormTitle
        
        view.addSubview(titleLabel)
        view.addSubview(contentScrollView)
        view.addSubview(footerButtonsStackView)
        
        contentScrollView.addSubview(nameInputField)
        contentScrollView.addSubview(trackerOptionsView)
        
        footerButtonsStackView.addArrangedSubview(cancelButton)
        footerButtonsStackView.addArrangedSubview(submitButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Spacing.space28),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            contentScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space16),
            contentScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space16),
            contentScrollView.bottomAnchor.constraint(equalTo: footerButtonsStackView.topAnchor),
            
            nameInputField.topAnchor.constraint(equalTo: contentScrollView.frameLayoutGuide.topAnchor, constant: Spacing.space24),
            nameInputField.leadingAnchor.constraint(equalTo: contentScrollView.frameLayoutGuide.leadingAnchor),
            nameInputField.trailingAnchor.constraint(equalTo: contentScrollView.frameLayoutGuide.trailingAnchor),
            
            trackerOptionsView.topAnchor.constraint(equalTo: nameInputField.bottomAnchor, constant: Spacing.space24),
            trackerOptionsView.leadingAnchor.constraint(equalTo: contentScrollView.frameLayoutGuide.leadingAnchor),
            trackerOptionsView.trailingAnchor.constraint(equalTo: contentScrollView.frameLayoutGuide.trailingAnchor),
            
            footerButtonsStackView.heightAnchor.constraint(equalToConstant: Constants.footerButtonsStackViewHeight),
            footerButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space20),
            footerButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space20),
            footerButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    @objc private func didTapSubmitButton(_ sender: UIButton) {
        guard let presenter else { return }
        
        let tracker = presenter.getTrackerModel()
        
        delegate?.trackerFormViewController(self, didCreateTracker: tracker)
    }
    
    @objc private func didTapCancelButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - TrackerOptionsViewDelegate
extension TrackerFormViewController: TrackerOptionsViewDelegate {
    func trackerOptionsView(_ view: TrackerOptionsView, didSelectOptionWith type: TrackerOptionType) {
        switch type {
        case .category:
            return
        case .schedule:
            let trackerScheduleVC = TrackerScheduleViewController()
            let scheduleViewPresenter = TrackerScheduleViewPresenter(selectedDays: presenter?.selectedDays ?? [])
            
            scheduleViewPresenter.view = trackerScheduleVC
            trackerScheduleVC.delegate = self
            trackerScheduleVC.presenter = scheduleViewPresenter
            
            present(trackerScheduleVC, animated: true)
        }
    }
}

// MARK: - TrackerScheduleViewControllerDelegate
extension TrackerFormViewController: TrackerScheduleViewControllerDelegate {
    func trackerScheduleViewController(_ vc: TrackerScheduleViewController, didFinishWith selectedDays: Weekdays) {
        presenter?.didChangeSelectedDays(selectedDays)
        
        vc.dismiss(animated: true)
    }
}

// MARK: - InputFieldViewDelegate
extension TrackerFormViewController: InputFieldViewDelegate {
    func inputFieldView(_ inputFieldView: InputFieldView, didChange text: String) {
        presenter?.didChangeTrackerName(text)
    }
}

// MARK: - Constants
private extension TrackerFormViewController {
    enum Constants {
        static let footerButtonsStackViewHeight: CGFloat = 60
        
        static let nameFieldPlaceholder = "Введите название трекера"
        static let submitButtonText = "Создать"
        static let cancelButtonText = "Отменить"
    }
}
