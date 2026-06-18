//
//  TrackersFilterOption.swift
//  Tracker
//
//  Created by Kislov Vadim on 17.06.2026.
//

import UIKit

final class TrackersFilterOption: UIView {
    
    // MARK: - Public properties
    var onTap: Completion?
    
    // MARK: - Private properties
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = Font.regular17
        label.textColor = .ypBlack
        
        return label
    }().forAutoLayout
    
    private lazy var accessoryImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(resource: .done)
        imageView.isHidden = true
        
        return imageView
    }().forAutoLayout
    
    private lazy var stackView: UIStackView = {
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
    
    // MARK: - Public methods
    func setDescription(with text: String) {
        descriptionLabel.text = text
    }
    
    func setSelected(_ selected: Bool) {
        accessoryImageView.isHidden = !selected
    }
    
    // MARK: - Private methods
    private func setElements() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)
        
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(accessoryImageView)
        
        addSubview(stackView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            accessoryImageView.heightAnchor.constraint(equalToConstant: Constants.accessoryImageSize),
            accessoryImageView.widthAnchor.constraint(equalToConstant: Constants.accessoryImageSize),
        ])
    }
    
    @objc private func didTap() {
        onTap?()
    }
}

// MARK: - Constants
private extension TrackersFilterOption {
    enum Constants {
        static let accessoryImageSize: CGFloat = 24
    }
}
