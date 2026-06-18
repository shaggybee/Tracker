//
//  TrackerCategoriesViewController.swift
//  Tracker
//
//  Created by Kislov Vadim on 04.06.2026.
//

import UIKit

final class TrackerCategoriesViewController: UIViewController {
    
    // MARK: - Public properties
    var onTrackerCategoryChanged: Binding<String?>?
    
    // MARK: - Private properties
    private var viewModel: TrackerCategoriesViewModelProtocol?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = Font.medium16
        label.textColor = .ypBlack
        label.text = NSLocalizedString(L10n.Category.title, comment: "")
        
        return label
    }().forAutoLayout
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .background
        tableView.layer.cornerRadius = Radius.size16
        tableView.isHidden = true
        tableView.showsVerticalScrollIndicator = false
        
        tableView.separatorColor = .ypGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: Spacing.space16, bottom: 0, right: Spacing.space16)
        
        return tableView
    }().forAutoLayout
    
    private lazy var emptyStateView: EmptyStateView = {
        let emptyStateView = EmptyStateView(
            model: EmptyStateModel(text: NSLocalizedString(L10n.Category.emptyState, comment: ""))
        )
        
        emptyStateView.isHidden = true
        
        return emptyStateView
    }().forAutoLayout
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(
            NSLocalizedString(L10n.Category.add, comment: ""),
            for: .normal
        )
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
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
        
        viewModel?.onShowCategoryForm = { [weak self] categoryFormViewModel in
            guard let self else { return }
            
            let updatingCategoryName = categoryFormViewModel.categoryName
            
            let categoryFormVC = TrackerCategoryFormViewController()
            
            categoryFormVC.initialize(viewModel: categoryFormViewModel)
            categoryFormVC.onComplete = { newCategoryName in
                if categoryFormViewModel.isEditMode {
                    self.viewModel?.didUpdateCategory(with: updatingCategoryName, by: newCategoryName)
                }
                
                self.dismiss(animated: true)
            }
            
            present(categoryFormVC, animated: true)
        }
        
        viewModel?.onCategoryChanged = { [weak self] categoryName in
            self?.onTrackerCategoryChanged?(categoryName)
        }
    }
    
    private func setElements() {
        configTable()
        updateEmptyState(viewModel?.isCategoriesEmpty ?? true)
        
        view.backgroundColor = .ypWhite
        
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
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.titleLabelHeight),
            
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
    
    private func showConfirmationDeleteAlert(for categoryName: String) {
        let alert = UIAlertController(
            title: NSLocalizedString(L10n.Category.deleteConfirmation, comment: ""),
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let delete = UIAlertAction(
            title: NSLocalizedString(L10n.Actions.delete, comment: ""),
            style: .destructive) { [weak self] _ in
            self?.viewModel?.deleteCategory(with: categoryName)
        }
        
        let cancel = UIAlertAction(
            title: NSLocalizedString(L10n.Actions.cancel, comment: ""),
            style: .cancel
        )
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    private func updateEmptyState(_ isEmpty: Bool) {
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
    @objc private func didTapAddCategoryButton(_ sender: UIButton) {
        viewModel?.didTapCreateCategory()
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
            isSelected: viewModel.isSelected(category: categoryName)
        )
        
        cell.separatorInset = indexPath.row == viewModel.categories.count - 1
            ? UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
            : UIEdgeInsets(top: 0, left: Spacing.space16, bottom: 0, right: Spacing.space16)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let categoryName = viewModel?.categories[safe: indexPath.row] else {
            return
        }
        
        viewModel?.didSelectCategory(categoryName)
    }
}

// MARK: - UITableViewDelegate
extension TrackerCategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let editAction = UIAction(
                title: NSLocalizedString(L10n.Actions.edit, comment: "")
            ) { _ in
                guard let self,
                      let categoryName = self.viewModel?.categories[safe: indexPath.row] else {
                    return
                }
                
                self.viewModel?.didTapUpdateCategory(with: categoryName)
            }
            
            let deleteAction = UIAction(
                title: NSLocalizedString(L10n.Actions.delete, comment: ""),
                attributes: .destructive
            ) { _ in
                guard let self,
                      let categoryName = self.viewModel?.categories[safe: indexPath.row] else {
                    return
                }
                
                self.showConfirmationDeleteAlert(for: categoryName)
            }
            
            return UIMenu(children: [editAction, deleteAction])
        }
    }
}

// MARK: - Constants
private extension TrackerCategoriesViewController {
    enum Constants {
        static let addCategoryButtonHeight: CGFloat = 60
        static let cellHeight: CGFloat = 75
        static let titleLabelHeight: CGFloat = 22
    }
}
