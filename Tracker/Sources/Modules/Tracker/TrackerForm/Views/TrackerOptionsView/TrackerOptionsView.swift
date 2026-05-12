//
//  TrackerOptionsView.swift
//  Tracker
//
//  Created by Kislov Vadim on 06.05.2026.
//

import UIKit

final class TrackerOptionsView: UIView {
    // MARK: - Public properties
    weak var delegate: TrackerOptionsViewDelegate?
    
    // MARK: - Private properties
    private var trackerOptions: [TrackerOptionType] = []
    
    private lazy var optionsStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: Spacing.space16,
            left: Spacing.space16,
            bottom: Spacing.space16,
            right: Spacing.space16
        )
        stackView.spacing = Spacing.space14
        
        return stackView
    }().forAutoLayout
    
    // MARK: - Initializers
    init(trackerOptions: [TrackerOptionType] = []) {
        super.init(frame: .zero)
        
        self.trackerOptions = trackerOptions
        
        setElements()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    func setDescription(for trackerOption: TrackerOptionType, with text: String) {
        let optionViews = optionsStackView.arrangedSubviews.compactMap { $0 as? TrackerOptionView }
        
        guard let index = trackerOptions.firstIndex(of: trackerOption),
              let optionView = optionViews[safe: index] else { return }
        
        optionView.setDescription(with: text)
    }
    
    // MARK: - Private methods
    private func setElements() {
        backgroundColor = .background
        clipsToBounds = true
        layer.cornerRadius = Radius.size16
        
        trackerOptions.forEach { optionType in
            let optionView = TrackerOptionView().forAutoLayout
            
            switch optionType {
            case .category:
                optionView.setTitle(with: Constants.titleForCategoryOption)
            case .schedule:
                optionView.setTitle(with: Constants.titleForScheduleOption)
            }
            
            optionView.onTap = { [weak self] in
                guard let self else { return }
                
                delegate?.trackerOptionsView(self, didSelectOptionWith: optionType)
            }
            
            optionsStackView.addArrangedSubview(optionView)
            
            if optionType != trackerOptions.last {
                let separatorView = getSeparatorView()
                
                optionsStackView.addArrangedSubview(separatorView)
            }
        }
        
        addSubview(optionsStackView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            optionsStackView.topAnchor.constraint(equalTo: topAnchor),
            optionsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            optionsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            optionsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func getSeparatorView() -> UIView {
        let separatorView = UIView(frame: .zero)
        
        separatorView.backgroundColor = .ypGray
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return separatorView.forAutoLayout
    }
}

// MARK: - Constants
private extension TrackerOptionsView {
    enum Constants {
        static let titleForCategoryOption: String = "Категория"
        static let titleForScheduleOption: String = "Расписание"
    }
}
