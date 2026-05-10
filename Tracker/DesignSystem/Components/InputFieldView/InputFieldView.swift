//
//  InputFieldView.swift
//  Tracker
//
//  Created by Kislov Vadim on 06.05.2026.
//

import UIKit

final class InputFieldView: UIView {
    
    var delegate: InputFieldViewDelegate?
    
    // MARK: - Private properties
    private lazy var textField: UITextField = {
        let textField = UITextField()
        
        textField.layer.cornerRadius = Radius.size16
        textField.backgroundColor = .background
        textField.clearButtonMode = .whileEditing
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Spacing.space16, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: Spacing.space16, height: 0))
        textField.rightViewMode = .unlessEditing
        
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        
        return textField
    }().forAutoLayout
    
    private lazy var hintLabel: UILabel = {
        let label = UILabel()
        
        label.font = Font.regular17
        label.textAlignment = .center
        label.textColor = .red
        label.isHidden = true
        
        return label
    }().forAutoLayout
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = Spacing.space8
        stackView.alignment = .fill
        
        return stackView
    }().forAutoLayout
    
    init(text: String = "", placeholder: String = "") {
        super.init(frame: .zero)
        
        textField.text = text
        textField.placeholder = placeholder
        
        setElements()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Public methods
    func setError(_ error: String?) {
        guard let error else {
            hintLabel.text = ""
            hintLabel.isHidden = true
            
            return
        }
        
        hintLabel.text = error
        hintLabel.isHidden = false
    }
    
    // MARK: - Private methods
    private func setElements() {
        textField.delegate = self
        
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(hintLabel)
        
        addSubview(stackView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            textField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight)
        ])
    }
    
    @objc private func textDidChange(_ textField: UITextField) {
        delegate?.inputFieldView(self, didChange: textField.text ?? "")
    }
}

extension InputFieldView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

// MARK: - Constants
private extension InputFieldView {
    enum Constants {
        static let textFieldHeight: CGFloat = 75
    }
}

