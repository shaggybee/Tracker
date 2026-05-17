//
//  TrackerColorViewCell.swift
//  Tracker
//
//  Created by Kislov Vadim on 16.05.2026.
//

import UIKit

final class TrackerColorViewCell: UICollectionViewCell {
    // MARK: - Static properties
    static let reuseIdentifier = Constants.cellReuseIdentifier
    
    // MARK: - Private properties
    private lazy var colorView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = Radius.size8
        
        return view
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
    func configure(with viewModel: TrackerColorCellViewModel) {
        let color = UIColor(hexString: viewModel.colorHex)
        
        colorView.backgroundColor = color
        
        if viewModel.isSelected {
            layer.borderColor = color.cgColor.copy(alpha: 0.3)
        } else {
            layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    // MARK: - Private methods
    private func setElements() {
        layer.cornerRadius = Radius.size8
        layer.borderWidth = Border.size3
        layer.borderColor = UIColor.clear.cgColor
        
        addSubview(colorView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.space6),
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space6),
            colorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.space6),
            colorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.space6)
        ])
    }
}

// MARK: - Constants
private extension TrackerColorViewCell {
    enum Constants {
        static let cellReuseIdentifier = "TrackerColorViewCell"
        
        static let buttonSize: CGFloat = 34
    }
}
