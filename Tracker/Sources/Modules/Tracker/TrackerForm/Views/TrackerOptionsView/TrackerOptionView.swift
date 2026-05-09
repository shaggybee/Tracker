//
//  TrackerOptionView.swift
//  Tracker
//
//  Created by Kislov Vadim on 09.05.2026.
//

import UIKit

final class TrackerOptionView: UIView {
    
    // MARK: - Public properties
    var onTap: (() -> Void)?
    
    // MARK: - Private properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = Font.regular17
        label.textColor = .ypBlack
        
        return label
    }().forAutoLayout
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = Font.regular17
        label.textColor = .ypGray
        label.isHidden = true
        
        return label
    }().forAutoLayout
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = Spacing.space2
        
        return stackView
    }().forAutoLayout
    
    private lazy var accessoryImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(resource: .chevronRight)
        
        return imageView
    }().forAutoLayout
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.spacing = Spacing.space16
        stackView.alignment = .center
        
        return stackView
    }().forAutoLayout
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        
        setElements()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    func setTitle(with text: String) {
        titleLabel.text = text
    }
    
    // MARK: - Public methods
    func setDescription(with text: String) {
        descriptionLabel.text = text
        descriptionLabel.isHidden = text.isEmpty
    }
    
    // MARK: - Private methods
    private func setElements() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)
        
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(descriptionLabel)
        
        mainStackView.addArrangedSubview(labelsStackView)
        mainStackView.addArrangedSubview(accessoryImageView)
        
        addSubview(mainStackView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.heightAnchor.constraint(equalToConstant: Constants.viewHeight),
            
            accessoryImageView.heightAnchor.constraint(equalToConstant: Constants.accessoryImageSize),
            accessoryImageView.widthAnchor.constraint(equalToConstant: Constants.accessoryImageSize),
        ])
    }
    
    @objc private func didTap() {
        onTap?()
    }
}

// MARK: - Constants
private extension TrackerOptionView {
    enum Constants {
        static let viewHeight: CGFloat = 46
        static let accessoryImageSize: CGFloat = 24
    }
}
