//
//  TrackerCategoryFormViewController.swift
//  Tracker
//
//  Created by Kislov Vadim on 05.06.2026.
//

import UIKit

final class TrackerCategoryFormViewController: UIViewController {
    
    // MARK: - Public properties
    var onComplete: Binding<String>?
    
    // MARK: - Private properties
    private var viewModel: TrackerCategoryFormViewModelProtocol?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = Font.medium16
        
        return label
    }().forAutoLayout
    
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElements()
    }
    
    // MARK: - Public methods
    func initialize(viewModel: TrackerCategoryFormViewModelProtocol) {
        self.viewModel = viewModel
        
        bind()
    }
    
    // MARK: - Private methods
    private func bind() {
        guard var viewModel else { return }
        
        viewModel.onSaveEnabledChanged = { [weak self] isEnabled in
            self?.setSubmitButtonEnabled(isEnabled)
        }
        
        viewModel.onCategoryNameErrorChanged = { [weak self] error in
            self?.nameInputField.setError(error)
        }
        
        viewModel.onSaveFailed = { [weak self] error in
            guard let error = error, !error.isEmpty else {
                return
            }
            
            self?.showAlert(with: error)
        }
        
        viewModel.onSaveCompleted = { [weak self] categoryName in
            guard let self else { return }
            
            self.onComplete?(categoryName)
        }
    }
    
    private func setSubmitButtonEnabled(_ isEnabled: Bool) {
        if submitButton.isEnabled == isEnabled { return }
        
        submitButton.isEnabled = isEnabled
        
        if (isEnabled) {
            submitButton.backgroundColor = .ypBlack
        } else {
            submitButton.backgroundColor = .ypGray
        }
    }
    
    private func setElements() {
        titleLabel.text = viewModel?.title ?? ""
        
        nameInputField.delegate = self
        nameInputField.setText(viewModel?.categoryName ?? "")
        
        setSubmitButtonEnabled(viewModel?.isSaveEnabled ?? false)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(nameInputField)
        view.addSubview(submitButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Spacing.space28),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.titleLableHeight),
            
            nameInputField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.space38),
            nameInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space16),
            nameInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space16),
            
            submitButton.heightAnchor.constraint(equalToConstant: Constants.submitButtonHeight),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space20),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space20),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Spacing.space16),
        ])
    }
    
    private func showAlert(with error: String) {
        let alert = UIAlertController(
            title: Constants.Alert.title,
            message: error,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: Constants.Alert.buttonText, style: .default) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc private func didTapSubmitButton(_ sender: UIButton) {
        viewModel?.save()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - InputFieldViewDelegate
extension TrackerCategoryFormViewController: InputFieldViewDelegate {
    func inputFieldView(_ inputFieldView: InputFieldView, didChange text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel?.didChange(text: trimmedText)
    }
}

// MARK: - Constants
private extension TrackerCategoryFormViewController {
    enum Constants {
        static let submitButtonHeight: CGFloat = 60
        static let titleLableHeight: CGFloat = 22
        
        static let nameFieldPlaceholder = "Введите название категории"
        static let submitButtonText = "Готово"
        
        enum Alert {
            static let title = "Что-то пошло не так"
            static let buttonText = "Ok"
        }
    }
}
