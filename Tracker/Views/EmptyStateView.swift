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
        stackView.spacing = Spacing.sm
        stackView.alignment = .center
        
        return stackView
    }().forAutoLayout
    
    init(text: String, image: ImageResource = .emptyState) {
        super.init(frame: .zero)
        
        configure(text: text, image: image)
        setElements()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    func configure(text: String, image: ImageResource) {
        label.text = text
        imageView.image = UIImage(resource: image)
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
            
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

private extension EmptyStateView {
    enum Constants {
        static let imageSize: CGFloat = 80
    }
}
