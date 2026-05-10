//
//  SearchBarView.swift
//  Tracker
//
//  Created by Kislov Vadim on 06.05.2026.
//

import UIKit

final class SearchBarView: UIView {
    
    var delegate: SearchBarViewDelegate?
    
    // MARK: - Private properties
    private lazy var textField: UITextField = {
        let textField = UITextField()
        
        textField.addTarget(
            self,
            action: #selector(textDidChange(_:)),
            for: .editingChanged)
        
        return textField
    }().forAutoLayout
    
    private lazy var searchImageView: UIImageView = {
        let imageView = UIImageView(image: .magnifyingGlass)
        
        imageView.tintColor = .ypGray
        
        return imageView
    }().forAutoLayout
    
    private lazy var searchBarStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.spacing = Spacing.space6
        stackView.layer.cornerRadius = Radius.size10
        stackView.backgroundColor = .searchBarBackground
        stackView.alignment = .center
        stackView.distribution = .fill
        
        stackView.layoutMargins = UIEdgeInsets(
            top: 0,
            left: Spacing.space8,
            bottom: 0,
            right: Spacing.space8
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }().forAutoLayout
    
    private lazy var searchContainerStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.spacing = Spacing.space6
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        return stackView
    }().forAutoLayout
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.isHidden = true
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypBlue, for: .normal)
        
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        button.addTarget(
            self,
            action: #selector(didTapCancelButton),
            for: .touchUpInside)
        
        return button
    }().forAutoLayout
    
    init(placeholder: String = "Поиск") {
        super.init(frame: .zero)
        
        textField.placeholder = placeholder
        
        setElements()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    private func setElements() {
        textField.delegate = self
        
        searchBarStackView.addArrangedSubview(searchImageView)
        searchBarStackView.addArrangedSubview(textField)
        
        searchContainerStackView.addArrangedSubview(searchBarStackView)
        searchContainerStackView.addArrangedSubview(cancelButton)
        
        addSubview(searchContainerStackView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            searchContainerStackView.topAnchor.constraint(equalTo: topAnchor),
            searchContainerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            searchContainerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchContainerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            searchImageView.widthAnchor.constraint(equalToConstant: Constants.searchImageSize),
            searchImageView.heightAnchor.constraint(equalToConstant: Constants.searchImageSize),
            searchBarStackView.heightAnchor.constraint(equalToConstant: Constants.searchBarStackViewHeight),
            cancelButton.heightAnchor.constraint(equalToConstant: Constants.cancelButtonHeight)
        ])
    }
    
    @objc private func textDidChange(_ textField: UITextField) {
        cancelButton.isHidden = textField.text?.isEmpty ?? true
        
        delegate?.searchBarView(self, didChange: textField.text ?? "")
    }
    
    @objc private func didTapCancelButton() {
        textField.text = ""
        
        textDidChange(textField)
    }
}

extension SearchBarView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

// MARK: - Constants
private extension SearchBarView {
    enum Constants {
        static let cancelButtonHeight: CGFloat = 22
        static let searchImageSize: CGFloat = 16
        static let searchBarStackViewHeight: CGFloat = 36
    }
}


