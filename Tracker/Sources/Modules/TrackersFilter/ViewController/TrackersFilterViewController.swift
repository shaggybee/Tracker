//
//  TrackersFilterViewController.swift
//  Tracker
//
//  Created by Kislov Vadim on 17.06.2026.
//

import UIKit

final class TrackersFilterViewController: UIViewController {
    
    // MARK: - Public properties
    var onFilterSelect: Binding<TrackersFilter>?
    
    // MARK: - Private properties
    private var viewModel: TrackersFilterViewModelProtocol?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = Font.medium16
        label.textColor = .ypBlack
        label.text = NSLocalizedString(L10n.Trackers.Filters.title, comment: "")
        
        return label
    }().forAutoLayout
    
    private lazy var optionsStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: 0,
            left: Spacing.space16,
            bottom: 0,
            right: Spacing.space16
        )
        
        stackView.backgroundColor = .background
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = Radius.size16
        
        return stackView
    }().forAutoLayout
    
    // MARK: - Public methods
    func initialize(viewModel: TrackersFilterViewModelProtocol) {
        self.viewModel = viewModel
        
        bind()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setElements()
    }
    
    // MARK: - Private methods
    private func bind() {
        viewModel?.onClose = { [weak self] in
            guard let self, let viewModel else { return }
            
            onFilterSelect?(viewModel.selectedFilter)
            
            dismiss(animated: true)
        }
    }
    
    private func setElements() {
        view.backgroundColor = .ypWhite
        
        TrackersFilter.allCases.forEach { filter in
            let optionView = TrackersFilterOption().forAutoLayout
            
            optionView.heightAnchor.constraint(equalToConstant: Constants.filterOptionViewHeight).isActive = true
            
            optionView.setDescription(with: filter.description ?? "")
            
            if viewModel?.selectedFilter == .completed || viewModel?.selectedFilter == .unfinished {
                optionView.setSelected(filter == viewModel?.selectedFilter)
            }
            
            optionView.onTap = { [weak self] in
                self?.viewModel?.select(filter)
            }
            
            optionsStackView.addArrangedSubview(optionView)
            
            if filter != TrackersFilter.allCases.last {
                let separatorView = getSeparatorView()
                
                optionsStackView.addArrangedSubview(separatorView)
            }
        }
        
        view.addSubview(titleLabel)
        view.addSubview(optionsStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Spacing.space28),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.titleLabelHeight),
            
            optionsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.space24),
            optionsStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
            optionsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space16),
            optionsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space16),
        ])
    }
    
    private func getSeparatorView() -> UIView {
        let separatorView = UIView(frame: .zero)
        
        separatorView.backgroundColor = .ypGray
        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        return separatorView.forAutoLayout
    }
}

// MARK: - Constants
private extension TrackersFilterViewController {
    enum Constants {
        static let titleLabelHeight: CGFloat = 22
        static let filterOptionViewHeight: CGFloat = 75
    }
}
