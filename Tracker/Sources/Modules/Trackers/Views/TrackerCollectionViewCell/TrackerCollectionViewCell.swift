//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Kislov Vadim on 09.05.2026.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    // MARK: - Static properties
    static let reuseIdentifier = Constants.cellReuseIdentifier
    
    // MARK: - Public properties
    weak var delegate: TrackerCollectionViewCellDelegate?
    
    // MARK: - Private properties
    private var availableActionState: TrackerAvailableAction = .none {
        didSet {
            configureCompleteButton()
        }
    }
    
    private lazy var cardView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = Radius.size16
        
        return view
    }().forAutoLayout
    
    private lazy var trackerNameLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 2
        label.textColor = .white
        label.font = Font.medium12
        
        return label
    }().forAutoLayout
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .ypBlack
        label.font = Font.medium12
        
        return label
    }().forAutoLayout
    
    private lazy var completeButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.clipsToBounds = true
        button.tintColor = .white
        button.layer.cornerRadius = Constants.buttonSize / 2
        
        button.addTarget(
             self,
             action: #selector(didTapCompleteButton),
             for: .touchUpInside
         )
        
        return button
    }().forAutoLayout
    
    private lazy var footerStackView: UIStackView = {
        let stack = UIStackView()
        
        stack.spacing = Spacing.space8
        stack.axis = .horizontal
        stack.alignment = .center
        
        return stack
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
    func configure(with model: TrackerViewModel) {
        trackerNameLabel.text = model.name
        countLabel.text = model.completedDaysCount.formatRussianPlural(for: (one: "день", few: "дня", many: "дней"))
        cardView.backgroundColor = UIColor(hexString: model.colorHex)
        completeButton.backgroundColor = UIColor(hexString: model.colorHex)
        availableActionState = model.availableAction
    }
    
    // MARK: - Private methods
    private func setElements() {
        configureCompleteButton()
        
        cardView.addSubview(trackerNameLabel)
        footerStackView.addArrangedSubview(countLabel)
        footerStackView.addArrangedSubview(completeButton)
        
        contentView.addSubview(cardView)
        contentView.addSubview(footerStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: Constants.cardViewHeight),
            
            trackerNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Spacing.space12),
            trackerNameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -Spacing.space12),
            trackerNameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -Spacing.space12),
            
            footerStackView.topAnchor.constraint(equalTo: cardView.bottomAnchor),
            footerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.space12),
            footerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.space12),
            footerStackView.heightAnchor.constraint(equalToConstant: Constants.footerStackViewHeight),
            footerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spacing.space8),
            
            completeButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize),
            completeButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize)
        ])
    }
    
    private func configureCompleteButton() {
        switch availableActionState {
        case .complete:
            completeButton.alpha = 1
            completeButton.setImage(UIImage(systemName: "plus"), for: .normal)
        case .uncomplete:
            completeButton.alpha = 0.3
            completeButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        case .none:
            completeButton.isHidden = true
            
            return
        }
        
        completeButton.isHidden = false
    }
    
    @objc private func didTapCompleteButton() {
        if availableActionState == .none { return }

        let isCompleted = availableActionState == .complete
        
        delegate?.trackerCollectionViewCell(self, didToggleCompleted: isCompleted)
    }
}

// MARK: - Constants
private extension TrackerCollectionViewCell {
    enum Constants {
        static let cellReuseIdentifier = "TrackerCollectionViewCell"
        
        static let buttonSize: CGFloat = 34
        static let cardViewHeight: CGFloat = 90
        static let footerStackViewHeight: CGFloat = 50
    }
}
