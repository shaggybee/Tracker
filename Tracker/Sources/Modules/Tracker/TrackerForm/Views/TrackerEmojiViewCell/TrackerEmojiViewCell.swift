//
//  TrackerEmojiViewCell.swift
//  Tracker
//
//  Created by Kislov Vadim on 16.05.2026.
//

import UIKit

final class TrackerEmojiViewCell: UICollectionViewCell {
    // MARK: - Static properties
    static let reuseIdentifier = Constants.cellReuseIdentifier
    
    // MARK: - Private properties
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .ypBlack
        label.font = Font.bold32
        
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
    func configure(with viewModel: TrackerEmojiCellViewModel) {
        emojiLabel.text = viewModel.emoji
        
        backgroundColor = viewModel.isSelected ? .ypLightGray  : UIColor.clear
    }
    
    // MARK: - Private methods
    private func setElements() {
        layer.cornerRadius = Radius.size16
        
        addSubview(emojiLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

// MARK: - Constants
private extension TrackerEmojiViewCell {
    enum Constants {
        static let cellReuseIdentifier = "TrackerEmojiViewCell"
        
        static let buttonSize: CGFloat = 34
    }
}
