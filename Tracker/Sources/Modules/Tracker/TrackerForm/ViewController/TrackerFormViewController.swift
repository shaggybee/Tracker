//
//  TrackerFormViewController.swift
//  Tracker
//
//  Created by Kislov Vadim on 05.05.2026.
//

import UIKit

final class TrackerFormViewController: UIViewController, TrackerFormViewControllerProtocol {
    
    // MARK: - Public properties
    var presenter: TrackerFormViewPresenterProtocol?
    
    // MARK: - Private properties
    private var trackerAppearanceCollectionModel: TrackerAppearanceCollectionModel = TrackerAppearanceCollectionModel(sections: [])
    private var trackerAppearanceDataSource: UICollectionViewDiffableDataSource<String, TrackerAppearanceItem>!
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = Font.medium16
        label.textColor = .ypBlack
        
        return label
    }().forAutoLayout
    
    private lazy var completedDaysCountLabel: UILabel = {
        let label = UILabel()
        
        label.font = Font.bold32
        label.textColor = .ypBlack
        label.textAlignment = .center
        
        return label
    }().forAutoLayout
    
    private lazy var contentScrollView: UIScrollView = {
        let collectionView = UIScrollView()
        
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }().forAutoLayout
    
    private lazy var nameInputField: InputFieldView = {
        let inputFieldView = InputFieldView(
            placeholder: NSLocalizedString(L10n.Tracker.nameFieldPlaceholder, comment: "")
        )
        
        return inputFieldView
    }().forAutoLayout
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(
            presenter?.submitButtonTitle ?? "",
            for: .normal
        )
        button.backgroundColor = .ypGray
        button.isEnabled = false
        button.layer.cornerRadius = Radius.size16
        button.addTarget(
            self,
            action: #selector(didTapSubmitButton(_:)),
            for: .touchUpInside)
        
        return button
    }().forAutoLayout
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(
            NSLocalizedString(L10n.Actions.cancel, comment: ""),
            for: .normal
        )
        button.backgroundColor = .ypWhite
        button.layer.cornerRadius = Radius.size16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.setTitleColor(.red, for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapCancelButton(_:)),
            for: .touchUpInside)
        
        return button
    }().forAutoLayout
    
    private lazy var footerButtonsStackView: UIStackView = {
        let stack = UIStackView()
        
        stack.spacing = Spacing.space8
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        return stack
    }().forAutoLayout
    
    private lazy var trackerOptionsView: TrackerOptionsView = {
        let trackerOptionsView = TrackerOptionsView(trackerOptions: presenter?.trackerOptions ?? [])
        
        return trackerOptionsView
    }().forAutoLayout
    
    private lazy var trackerAppearanceCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.sectionInset = UIEdgeInsets(
            top: Spacing.space24,
            left: Spacing.space2,
            bottom: 0,
            right: Spacing.space2)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        collectionView.isScrollEnabled = false
        
        return collectionView
    }().forAutoLayout
    
    private lazy var trackerAppearanceCollectionViewHeightConstraint = trackerAppearanceCollectionView.heightAnchor.constraint(equalToConstant: 0)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElements()
        presenter?.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateCollectionHeight()
    }
    
    // MARK: - Public methods
    func apply(_ model: TrackerAppearanceCollectionModel) {
        trackerAppearanceCollectionModel = model
        
        var snapshot = NSDiffableDataSourceSnapshot<String, TrackerAppearanceItem>()
        
        model.sections.forEach { section in
            snapshot.appendSections([section.name])
            snapshot.appendItems(section.items, toSection: section.name)
        }
        
        trackerAppearanceDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func setSubmitButtonEnabled(_ isEnabled: Bool) {
        if submitButton.isEnabled == isEnabled { return }
        
        submitButton.isEnabled = isEnabled
        submitButton.backgroundColor = isEnabled ? .ypBlack: .ypGray
    }
    
    func setTrackerNameFieldError(_ error: String?) {
        nameInputField.setError(error)
    }
    
    func setTrackerNameField(text: String) {
        nameInputField.setText(text)
    }
    
    func setDescription(for trackerOption: TrackerOptionType, with text: String) {
        trackerOptionsView.setDescription(for: trackerOption, with: text)
    }
    
    // MARK: - Private methods
    private func setElements() {
        trackerOptionsView.delegate = self
        nameInputField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        view.backgroundColor = .ypWhite
        
        titleLabel.text = presenter?.trackerFormTitle
        
        configureTackerAppearanceCollectionView()
        
        view.addSubview(titleLabel)
        view.addSubview(contentScrollView)
        view.addSubview(footerButtonsStackView)
        
        if presenter?.isEditMode == true {
            completedDaysCountLabel.text = String.localizedStringWithFormat(
                NSLocalizedString(L10n.Other.days, comment: ""),
                presenter?.completedDaysCount ?? 0
            )
            
            contentScrollView.addSubview(completedDaysCountLabel)
        }
        
        contentScrollView.addSubview(nameInputField)
        contentScrollView.addSubview(trackerOptionsView)
        contentScrollView.addSubview(trackerAppearanceCollectionView)
        
        footerButtonsStackView.addArrangedSubview(cancelButton)
        footerButtonsStackView.addArrangedSubview(submitButton)
        
        setupConstraints()
    }
    
    private func configureTackerAppearanceCollectionView() {
        trackerAppearanceDataSource = UICollectionViewDiffableDataSource(
            collectionView: trackerAppearanceCollectionView,
            cellProvider: getCellViewProvider(collectionView:indexPath:itemModel:))
        
        trackerAppearanceDataSource.supplementaryViewProvider = getHeaderViewProvider
        
        trackerAppearanceCollectionView.delegate = self
        
        trackerAppearanceCollectionView.register(
            TrackerColorViewCell.self,
            forCellWithReuseIdentifier: TrackerColorViewCell.reuseIdentifier)
        
        trackerAppearanceCollectionView.register(
            TrackerEmojiViewCell.self,
            forCellWithReuseIdentifier: TrackerEmojiViewCell.reuseIdentifier)
        
        trackerAppearanceCollectionView.register(
            TrackerCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCollectionViewHeader.reuseIdentifier)
    }
    
    private func setupConstraints() {
        let editModeConstraints: [NSLayoutConstraint] = [
            completedDaysCountLabel.topAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.topAnchor),
            completedDaysCountLabel.leadingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.leadingAnchor),
            completedDaysCountLabel.trailingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.trailingAnchor),
            nameInputField.topAnchor.constraint(equalTo: completedDaysCountLabel.bottomAnchor, constant: Spacing.space40),
        ]
        
        let createModeConstraints: [NSLayoutConstraint] = [
            nameInputField.topAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.topAnchor),
        ]
        
        if presenter?.isEditMode == true {
            NSLayoutConstraint.activate(editModeConstraints)
        } else {
            NSLayoutConstraint.activate(createModeConstraints)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Spacing.space28),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            contentScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.space24),
            contentScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space16),
            contentScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space16),
            contentScrollView.bottomAnchor.constraint(equalTo: footerButtonsStackView.topAnchor, constant: -Spacing.space16),
            contentScrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: contentScrollView.frameLayoutGuide.widthAnchor),
            
            nameInputField.leadingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.leadingAnchor),
            nameInputField.trailingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.trailingAnchor),
            
            trackerOptionsView.topAnchor.constraint(equalTo: nameInputField.bottomAnchor, constant: Spacing.space24),
            trackerOptionsView.leadingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.leadingAnchor),
            trackerOptionsView.trailingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.trailingAnchor),
            
            footerButtonsStackView.heightAnchor.constraint(equalToConstant: Constants.footerButtonsStackViewHeight),
            footerButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space20),
            footerButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space20),
            footerButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            trackerAppearanceCollectionView.topAnchor.constraint(equalTo: trackerOptionsView.bottomAnchor, constant: Spacing.space16),
            trackerAppearanceCollectionView.leadingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.leadingAnchor),
            trackerAppearanceCollectionView.trailingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.trailingAnchor),
            trackerAppearanceCollectionView.bottomAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.bottomAnchor),
            
            trackerAppearanceCollectionViewHeightConstraint
        ])
    }
    
    private func updateCollectionHeight() {
        trackerAppearanceCollectionView.layoutIfNeeded()
        
        let contentHeight = trackerAppearanceCollectionView.collectionViewLayout.collectionViewContentSize.height
        trackerAppearanceCollectionViewHeightConstraint.constant = contentHeight
    }
    
    private func getCellViewProvider(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        itemModel: TrackerAppearanceItem
    ) -> UICollectionViewCell? {
        switch itemModel {
        case .emoji(let trackerEmojiCellModel):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackerEmojiViewCell.reuseIdentifier,
                for: indexPath)
            
            
            guard let cell = cell as? TrackerEmojiViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: trackerEmojiCellModel)
            
            return cell
        case .color(let trackerColorCellModel):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackerColorViewCell.reuseIdentifier,
                for: indexPath)
            
            guard let cell = cell as? TrackerColorViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: trackerColorCellModel)
            
            return cell
        }
    }
    
    private func getHeaderViewProvider(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if (kind != UICollectionView.elementKindSectionHeader) {
            return UICollectionReusableView()
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerCollectionViewHeader.reuseIdentifier,
            for: indexPath)
        
        guard let headerView = headerView as? TrackerCollectionViewHeader else {
            return UICollectionReusableView()
        }
        
        headerView.configure(with: trackerAppearanceCollectionModel.sections[safe: indexPath.section]?.name ?? "")
        
        return headerView
    }
    
    @objc private func didTapSubmitButton(_ sender: UIButton) {
        guard let presenter else { return }
        
        if (presenter.isEditMode) {
            presenter.updateTracker()
        } else {
            presenter.createTracker()
        }
        
        view.window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc private func didTapCancelButton(_ sender: UIButton) {
        view.window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - TrackerOptionsViewDelegate
extension TrackerFormViewController: TrackerOptionsViewDelegate {
    func trackerOptionsView(_ view: TrackerOptionsView, didSelectOptionWith type: TrackerOptionType) {
        switch type {
        case .category:
            let trackerCategoriesVC = TrackerCategoriesViewController()
            let viewModel = TrackerCategoriesViewModel(currentCategory: presenter?.categoryName)
            
            trackerCategoriesVC.initialize(viewModel: viewModel)
            trackerCategoriesVC.onTrackerCategoryChanged = { [weak self] categoryName in
                guard let self else { return }
                
                presenter?.didChangeTrackerCategory(categoryName)
                
                if ((categoryName ?? "").isEmpty) { return }
                
                dismiss(animated: true)
            }
            
            present(trackerCategoriesVC, animated: true)
        case .schedule:
            let trackerScheduleVC = TrackerScheduleViewController()
            let scheduleViewPresenter = TrackerScheduleViewPresenter(selectedDays: presenter?.selectedDays ?? [])
            
            scheduleViewPresenter.view = trackerScheduleVC
            trackerScheduleVC.delegate = self
            trackerScheduleVC.presenter = scheduleViewPresenter
            
            present(trackerScheduleVC, animated: true)
        }
    }
}

// MARK: - TrackerScheduleViewControllerDelegate
extension TrackerFormViewController: TrackerScheduleViewControllerDelegate {
    func trackerScheduleViewController(_ vc: TrackerScheduleViewController, didFinishWith selectedDays: Weekdays) {
        presenter?.didChangeSelectedDays(selectedDays)
        
        vc.dismiss(animated: true)
    }
}

// MARK: - InputFieldViewDelegate
extension TrackerFormViewController: InputFieldViewDelegate {
    func inputFieldView(_ inputFieldView: InputFieldView, didChange text: String) {
        presenter?.didChangeTrackerName(text)
    }
}

// MARK: - UICollectionViewDelegate
extension TrackerFormViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = trackerAppearanceDataSource.itemIdentifier(for: indexPath) else { return }
        
        switch item {
        case .emoji(let trackerEmojiCellModel) where !trackerEmojiCellModel.isSelected:
            presenter?.didChangeSelectedEmoji(trackerEmojiCellModel.emoji)
        case .color(let trackerColorCellModel) where !trackerColorCellModel.isSelected:
            presenter?.didChangeSelectedColor(trackerColorCellModel.colorHex)
        default:
            break
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackerFormViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let size = (collectionView.bounds.width / CGFloat(Constants.rowItemsCount)) - Spacing.space4
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: Constants.headerSectionHeight)
    }
}

// MARK: - Constants
private extension TrackerFormViewController {
    enum Constants {
        static let footerButtonsStackViewHeight: CGFloat = 60
        static let headerSectionHeight: CGFloat = 34
        static let rowItemsCount: Int = 6
    }
}
