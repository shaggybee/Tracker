//
//  EmptyStateView.swift
//  Tracker
//
//  Created by Kislov Vadim on 02.05.2026.
//

import UIKit

final class EmptyStateView: UIView {
    // MARK: - Private properties
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        
        return image
    }().forAutoLayout
    
    private lazy var label: UILabel = {
        let label = UILabel()
        
        label.font = Font.medium12
        label.textColor = .ypBlack
        label.textAlignment = .center
        
        return label
    }().forAutoLayout
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = Spacing.space8
        stackView.alignment = .center
        
        return stackView
    }().forAutoLayout
    
    init(model: EmptyStateModel) {
        super.init(frame: .zero)
        
        configure(with: model)
        setElements()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    func configure(with model: EmptyStateModel) {
        label.text = model.text
        imageView.image = UIImage(resource: model.image)
    }
    
    private func setElements() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        addSubview(stackView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

// MARK: - Constants
private extension EmptyStateView {
    enum Constants {
        static let imageSize: CGFloat = 80
    }
}
