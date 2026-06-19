//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Kislov Vadim on 02.05.2026.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - Public properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = Font.bold34
        label.textColor = .ypBlack
        label.text = NSLocalizedString(L10n.Statistics.title, comment: "")
        
        return label
    }().forAutoLayout
    
    private lazy var emptyStateView: EmptyStateView = {
        let emptyStateView = EmptyStateView(
            model: EmptyStateModel(
                text: NSLocalizedString(L10n.Statistics.emptyState, comment: ""),
                image: .statisticsEmptyState
            )
        )
        
        emptyStateView.isHidden = true
        
        return emptyStateView
    }().forAutoLayout
    
    private lazy var cardsViewStack: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = Spacing.space12
        stackView.isHidden = true
        
        return stackView
    }().forAutoLayout
    
    // MARK: - Private properties
    private var viewModel: StatisticsViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.recalculateStatistics()
    }
    
    // MARK: - Public methods
    func initialize(viewModel: StatisticsViewModelProtocol) {
        self.viewModel = viewModel
        
        bind()
    }
    
    // MARK: - Private methods
    private func bind() {
        viewModel?.onStatisticsChanged = { [weak self] statisticsModel in
            guard let self else { return }
            
            guard let statisticsModel else {
                emptyStateView.isHidden = false
                cardsViewStack.isHidden = true
                
                return
            }
            
            emptyStateView.isHidden = true
            cardsViewStack.isHidden = false
            
            for view in cardsViewStack.arrangedSubviews {
                guard let view = view as? StatisticsCardView else {
                    return
                }
                
                switch view.type {
                case .averagePerDay:
                    view.configure(with: statisticsModel.averagePerDay)
                case .bestStreak:
                    view.configure(with: statisticsModel.bestStreak)
                case .completedTrackers:
                    view.configure(with: statisticsModel.completedTrackers)
                case .perfectDays:
                    view.configure(with: statisticsModel.perfectDays)
                }
            }
        }
    }
    
    private func setElements() {
        view.backgroundColor = .ypWhite
        
        for type in StatisticsCardType.allCases {
            let cardView = StatisticsCardView(type: type)
            
            cardsViewStack.addArrangedSubview(cardView)
        }
        
        view.addSubview(titleLabel)
        view.addSubview(emptyStateView)
        view.addSubview(cardsViewStack)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Spacing.space44),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space16),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            cardsViewStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardsViewStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space16),
            cardsViewStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space16)
        ])
    }
}
