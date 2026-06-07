//
//  TrackerCategoriesViewController.swift
//  Tracker
//
//  Created by Kislov Vadim on 04.06.2026.
//

import UIKit

final class TrackerCategoriesViewController: UIViewController {
    
    // MARK: - Public properties
    weak var delegate: TrackerCategoriesViewControllerDelegate?
    
    // MARK: - Private properties
    private var viewModel: TrackerCategoriesViewModelProtocol?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = Font.medium16
        label.text = Constants.title
        
        return label
    }().forAutoLayout
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .background
        tableView.layer.cornerRadius = Radius.size16
        tableView.isHidden = true
        tableView.separatorColor = .clear
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }().forAutoLayout
    
    private lazy var emptyStateView: EmptyStateView = {
        let emptyStateView = EmptyStateView(text: Constants.emptyStateText)
        
        emptyStateView.isHidden = true
        
        return emptyStateView
    }().forAutoLayout
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(Constants.addCategoryButtonText, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = Radius.size16
        button.addTarget(
            self,
            action: #selector(didTapAddCategoryButton(_:)),
            for: .touchUpInside)
        
        return button
    }().forAutoLayout
    
    private lazy var tableViewHeightConstraint: NSLayoutConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.loadCategories()
        setElements()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateTableHeight()
    }
    
    // MARK: - Public methods
    func initialize(viewModel: TrackerCategoriesViewModelProtocol) {
        self.viewModel = viewModel
        
        bind()
    }
    
    // MARK: - Private methods
    private func bind() {
        viewModel?.onCategoriesLoaded = { [weak self] in
            guard let self else { return }
            
            let isEmpty = viewModel?.isCategoriesEmpty ?? true
            
            updateEmptyState(isEmpty)
            
            if isEmpty { return }
            
            tableView.reloadData()
            updateTableHeight()
        }
    }
    
    private func setElements() {
        configTable()
        updateEmptyState(viewModel?.isCategoriesEmpty ?? true)
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        view.addSubview(addCategoryButton)
        
        setupConstraints()
    }
    
    private func configTable() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            TrackerCategoriesTableViewCell.self,
            forCellReuseIdentifier: TrackerCategoriesTableViewCell.reuseIdentifier)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Spacing.space28),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.titleLableHeight),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.space38),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: addCategoryButton.topAnchor, constant: -Spacing.space16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space16),
            
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space16),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space16),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            addCategoryButton.heightAnchor.constraint(equalToConstant: Constants.addCategoryButtonHeight),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Spacing.space16),
            
            tableViewHeightConstraint
        ])
    }
    
    private func updateTableHeight() {
        guard let viewModel, !tableView.isHidden else {
            return
        }
        
        tableView.layoutIfNeeded()
        
        let availableHeight = addCategoryButton.frame.minY - titleLabel.frame.maxY - Spacing.space38 - Spacing.space16
        
        if availableHeight <= 0 { return }
        
        let contentHeight = Constants.cellHeight * CGFloat(viewModel.categories.count)
        let newTableHeight = min(availableHeight, contentHeight)
        
        if newTableHeight == tableViewHeightConstraint.constant { return }
        
        tableViewHeightConstraint.constant = newTableHeight
        tableView.isScrollEnabled = contentHeight > availableHeight
    }
    
    private func updateEmptyState(_ isEmpty: Bool) {
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
    @objc private func didTapAddCategoryButton(_ sender: UIButton) {
        let categoryFormVC = TrackerCategoryFormViewController()
        
        let viewModel = TrackerCategoryFormViewModel(
            model: TrackerCategoryFormModel()
        )
        
        categoryFormVC.initialize(viewModel: viewModel)
        categoryFormVC.delegate = self
        
        present(categoryFormVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TrackerCategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.categories.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TrackerCategoriesTableViewCell.reuseIdentifier,
            for: indexPath)
        
        guard let cell = cell as? TrackerCategoriesTableViewCell,
              let viewModel,
              let categoryName = viewModel.categories[safe: indexPath.row]
        else {
            return UITableViewCell()
        }
        
        cell.configure(
            with: categoryName,
            isSelected: viewModel.isSelected(category: categoryName),
            withSeparator: indexPath.row != viewModel.categories.count - 1
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let categoryName = viewModel?.categories[safe: indexPath.row] else {
            return
        }
        
        delegate?.trackerCategoriesViewController(self, didChangeCategoryName: categoryName)
    }
}

// MARK: - UITableViewDelegate
extension TrackerCategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }
}

extension TrackerCategoriesViewController: TrackerCategoryFormViewControllerProtocol {
    func trackerCategoryFormViewControllerDidSave(_ viewController: TrackerCategoryFormViewController) {
        viewController.dismiss(animated: true)
    }
}

// MARK: - Constants
private extension TrackerCategoriesViewController {
    enum Constants {
        static let addCategoryButtonHeight: CGFloat = 60
        static let cellHeight: CGFloat = 75
        static let titleLableHeight: CGFloat = 22
        
        static let title = "Категория"
        static let addCategoryButtonText = "Добавить категорию"
        static let emptyStateText = "Привычки и события можно объединить по смыслу"
    }
}
