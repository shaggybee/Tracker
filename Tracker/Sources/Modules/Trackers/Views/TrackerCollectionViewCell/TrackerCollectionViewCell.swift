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
    private var completeButtonState: TrackerCellViewModel.ActionButtonState = .hidden {
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
        stack.distribution = .fill
        
        return stack
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
    func configure(with model: TrackerCellViewModel) {
        trackerNameLabel.text = model.name
        countLabel.text = "\(String(model.completedDaysCount)) дней"
        cardView.backgroundColor = model.color
        completeButton.backgroundColor = model.color
        completeButtonState = model.buttonState
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
            cardView.heightAnchor.constraint(equalToConstant: 90),
            
            trackerNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Spacing.space12),
            trackerNameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: Spacing.space12),
            trackerNameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -Spacing.space12),
            
            footerStackView.topAnchor.constraint(equalTo: cardView.bottomAnchor),
            footerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            footerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            footerStackView.heightAnchor.constraint(equalToConstant: 58),
        ])
    }
    
    private func configureCompleteButton() {
        switch completeButtonState {
        case .hidden:
            completeButton.isHidden = true
            
            return
        case .complete:
            completeButton.alpha = 0.3
            completeButton.setImage(UIImage(resource: .done), for: .normal)
        case .uncomplete:
            completeButton.alpha = 1
            completeButton.setImage(UIImage(resource: .plus), for: .normal)
        }
        
        completeButton.isHidden = false
    }
    
    @objc private func didTapCompleteButton() {
        if completeButtonState == .hidden { return }

        let isCompleted = completeButtonState == .uncomplete
        
        delegate?.trackerCollectionViewCell(self, didToggleCompleted: isCompleted)
    }
}

// MARK: - Constants
private extension TrackerCollectionViewCell {
    enum Constants {
        static let cellReuseIdentifier = "TrackerCollectionViewCell"
    }
}
