//
//  StatisticsCardView.swift
//  Tracker
//
//  Created by Kislov Vadim on 19.06.2026.
//

import UIKit

final class StatisticsCardView: UIView {
    
    // MARK: - Public properties
    let type: StatisticsCardType
    
    // MARK: - Private properties
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        
        label.font = Font.bold34
        label.textColor = .ypBlack
        
        return label
    }().forAutoLayout
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = Font.medium12
        label.textColor = .ypBlack
        
        return label
    }().forAutoLayout
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = Spacing.space8
        
        return stackView
    }().forAutoLayout
    
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - Initializers
    init(type: StatisticsCardType) {
        self.type = type
        
        super.init(frame: .zero)
        
        setElements()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureGradientBorder()
    }
    
    // MARK: - Public methods
    func configure(with count: Int) {
        guard valueLabel.text != String(count) else { return }
        
        valueLabel.text = String(count)
    }
    
    // MARK: - Private methods
    private func setElements() {
        backgroundColor = .ypWhite
        clipsToBounds = true
        layer.cornerRadius = Radius.size16
        
        descriptionLabel.text = type.title
        
        labelsStackView.addArrangedSubview(valueLabel)
        labelsStackView.addArrangedSubview(descriptionLabel)
        
        addSubview(labelsStackView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.space12),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space12),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.space12),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.space12),
        ])
    }
    
    private func configureGradientBorder() {
        guard !hasGradientBorderLayer() else { return }
        
        gradientLayer.name = Constants.cardGradientBorderLayerName
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor(hexString: "#FD4C49").cgColor,
            UIColor(hexString: "#46E69D").cgColor,
            UIColor(hexString: "#007BFA").cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        let shape = CAShapeLayer()
        
        shape.lineWidth = 1
        shape.path = UIBezierPath(
            roundedRect: bounds.insetBy(dx: 1, dy: 1),
            cornerRadius: Radius.size16
        ).cgPath
        
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.black.cgColor
        
        gradientLayer.mask = shape
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func hasGradientBorderLayer() -> Bool {
        layer.sublayers?.contains(where: { $0.name == Constants.cardGradientBorderLayerName }) ?? false
    }
}

// MARK: - Costants
private extension StatisticsCardView {
    enum Constants {
        static let cardGradientBorderLayerName = "cardGradientBorderLayer"
    }
}
