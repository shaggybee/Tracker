//
//  TrackerCollectionViewHeader.swift
//  Tracker
//
//  Created by Kislov Vadim on 09.05.2026.
//

import UIKit

final class TrackerCollectionViewHeader: UICollectionReusableView {
    // MARK: - Static properties
    static let reuseIdentifier = Constants.headerReuseIdentifier
    
    // MARK: - Private properties
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .ypBlack
        label.font = Font.bold19
        
        return label
    }().forAutoLayout
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setElements()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Public methods
    func configure(with title: String) {
        headerLabel.text = title
    }
    
    // MARK: - Private methods
    private func setElements() {
        addSubview(headerLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.space16),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space12),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

// MARK: - Constants
private extension TrackerCollectionViewHeader {
    enum Constants {
        static let headerReuseIdentifier = "TrackerCollectionViewHeader"
    }
}
