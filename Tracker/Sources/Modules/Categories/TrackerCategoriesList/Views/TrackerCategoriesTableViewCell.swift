//
//  TrackerCategoriesTableViewCell.swift
//  Tracker
//
//  Created by Kislov Vadim on 04.06.2026.
//

import UIKit

final class TrackerCategoriesTableViewCell: UITableViewCell {
    // MARK: - Static properties
    static let reuseIdentifier = Constants.cellReuseIdentifier
    
    // MARK: - Private properties
    private lazy var categoryNameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .ypBlack
        label.font = Font.regular17
        
        return label
    }().forAutoLayout
    
    private lazy var cellStackView: UIStackView = {
        let stack = UIStackView()
        
        stack.spacing = Spacing.space16
        stack.axis = .horizontal
        stack.distribution = .fill
        
        return stack
    }().forAutoLayout
    
    private lazy var selectedIndicatorImage: UIImageView = {
        let image = UIImageView(image: .done)
        
        image.isHidden = true
        image.contentMode = .scaleAspectFit
        
        return image
    }().forAutoLayout
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setElements()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Public methods
    func configure(with title: String, isSelected: Bool) {
        categoryNameLabel.text = title
        selectedIndicatorImage.isHidden = !isSelected
    }
    
    // MARK: - Private methods
    private func setElements() {
        backgroundColor = .background
        selectionStyle = .none
        
        cellStackView.addArrangedSubview(categoryNameLabel)
        cellStackView.addArrangedSubview(selectedIndicatorImage)
        
        contentView.addSubview(cellStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.space26),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spacing.space26),
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.space16),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.space16),
        ])
    }
}

// MARK: - Constants
private extension TrackerCategoriesTableViewCell {
    enum Constants {
        static let cellReuseIdentifier = "TrackerCategoriesTableViewCell"
    }
}
