//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Kislov Vadim on 02.05.2026.
//

import UIKit

final class TrackersViewController: UIViewController, TrackersViewControllerProtocol {
    
    // MARK: - Public properties
    var presenter: TrackersViewPresenterProtocol?
    
    // MARK: - Private properties
    private var trackersCollectionModel: TrackersCollectionModel = TrackersCollectionModel(sections: [])
    
    private var trackersDataSource: UICollectionViewDiffableDataSource<String, TrackerCellModel>!
    
    private lazy var addTrackerButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(resource: .plus), for: .normal)
        button.tintColor = .ypBlack
        button.addTarget(self, action:  #selector(didTapAddTracker(_:)), for: .touchUpInside)
        
        return button
    }().forAutoLayout
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(didChangeDate(_:)), for: .valueChanged)
        
        return datePicker
    }().forAutoLayout
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.alignment = .center
        
        return stackView
    }().forAutoLayout
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = Font.bold34
        label.textColor = .ypBlack
        label.text = NSLocalizedString(L10n.Trackers.title, comment: "")
        
        return label
    }().forAutoLayout
    
    private lazy var searchBarView: SearchBarView = {
        let textField = SearchBarView()
        
        return textField
    }().forAutoLayout
    
    private lazy var trackersCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.sectionInset = UIEdgeInsets(
            top: Spacing.space12,
            left: 0,
            bottom: 0,
            right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        collectionView.contentInset = .init(top: 0, left: Spacing.space16, bottom: 0, right: Spacing.space16)
        collectionView.isHidden = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .ypWhite
        
        return collectionView
    }().forAutoLayout
    
    private lazy var emptyStateView: EmptyStateView = {
        let emptyStateView = EmptyStateView(model: EmptyStateModel())
        
        emptyStateView.isHidden = true
        emptyStateView.backgroundColor = .ypWhite
        
        return emptyStateView
    }().forAutoLayout
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElements()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Public methods
    func apply(_ model: TrackersCollectionModel) {
        trackersCollectionModel = model
        
        var snapshot = NSDiffableDataSourceSnapshot<String, TrackerCellModel>()
        
        model.sections.forEach { section in
            snapshot.appendSections([section.name])
            snapshot.appendItems(section.trackers, toSection: section.name)
        }
        
        trackersDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func setEmptyState(with model: EmptyStateModel?) {
        guard let model else {
            emptyStateView.isHidden = true
            trackersCollectionView.isHidden = false
            
            return
        }
    
        emptyStateView.configure(with: model)
        emptyStateView.isHidden = false
        trackersCollectionView.isHidden = true
    }
    
    // MARK: - Private methods
    private func setElements() {
        view.backgroundColor = .ypWhite
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        searchBarView.delegate = self

        configureTrackersCollectionView()

        headerStackView.addArrangedSubview(addTrackerButton)
        headerStackView.addArrangedSubview(datePicker)
        
        view.addSubview(headerStackView)
        view.addSubview(titleLabel)
        view.addSubview(searchBarView)
        view.addSubview(emptyStateView)
        view.addSubview(trackersCollectionView)
        
        setupConstraints()
    }
    
    private func configureTrackersCollectionView() {
        trackersDataSource = UICollectionViewDiffableDataSource(
            collectionView: trackersCollectionView,
            cellProvider: getCellViewProvider(collectionView:indexPath:itemModel:))
        
        trackersDataSource.supplementaryViewProvider = getHeaderViewProvider
        
        trackersCollectionView.delegate = self
    
        trackersCollectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier)
        trackersCollectionView.register(
            TrackerCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCollectionViewHeader.reuseIdentifier)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space6),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space16),
            
            addTrackerButton.heightAnchor.constraint(equalToConstant: Constants.addTrackerButtonSize),
            addTrackerButton.widthAnchor.constraint(equalToConstant: Constants.addTrackerButtonSize),
            
            titleLabel.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: Spacing.separator),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Spacing.space16),
            
            searchBarView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.space8),
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space16),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space16),
            
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space16),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space16),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            trackersCollectionView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: Spacing.space8),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func getCellViewProvider(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        itemModel: TrackerCellModel
    ) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier,
            for: indexPath)
        
        guard let cell = cell as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        cell.configure(with: itemModel)
        
        return cell
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
        
        headerView.configure(with: trackersCollectionModel.sections[safe: indexPath.section]?.name ?? "")
        
        return headerView
    }
    
    private func getModelForCell(_ cell: UICollectionViewCell) -> TrackerCellModel? {
        guard let indexPath = trackersCollectionView.indexPath(for: cell),
              let model = trackersCollectionModel.sections[safe: indexPath.section]?.trackers[safe: indexPath.row] else { return nil }
        
        return model
    }
    
    private func showConfirmationDeleteAlert(for trackerId: UUID) {
        let alert = UIAlertController(
            title: NSLocalizedString(L10n.Tracker.deleteConfirmation, comment: ""),
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let delete = UIAlertAction(
            title: NSLocalizedString(L10n.Actions.delete, comment: ""),
            style: .destructive) { [weak self] _ in
                self?.presenter?.deleteTracker(with: trackerId)
        }
        
        let cancel = UIAlertAction(
            title: NSLocalizedString(L10n.Actions.cancel, comment: ""),
            style: .cancel
        )
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    @objc private func didChangeDate(_ sender: UIDatePicker) {
        presenter?.setDate(sender.date)
    }
    
    @objc private func didTapAddTracker(_ sender: UIButton) {
        let trackerTypeSelectionVC = TrackerTypeSelectionViewController()
        
        trackerTypeSelectionVC.delegate = self
        present(trackerTypeSelectionVC, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - TrackerTypeSelectionViewControllerDelegate
extension TrackersViewController: TrackerTypeSelectionViewControllerDelegate {
    func trackerTypeSelectionViewController(_ vc: TrackerTypeSelectionViewController, didSelect type: TrackerType) {
        let trackerFormVC = TrackerFormViewController()
        let presenter = TrackerFormViewPresenter(trackerType: type)
        presenter.view = trackerFormVC
        trackerFormVC.presenter = presenter
        
        vc.present(trackerFormVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate { }

// MARK: - SearchBarViewDelegate
extension TrackersViewController: SearchBarViewDelegate {
    func searchBarView(_ searchBarView: SearchBarView, didChange text: String) {
        presenter?.searchTrackers(with: text)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: ((collectionView.bounds.width - 2 * collectionView.contentInset.left) / 2) - Spacing.space4,
            height: Constants.collectionViewCellHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: Constants.headerSectionHeight)
    }
}

// MARK: - TrackerCollectionViewCellDelegate
extension TrackersViewController: TrackerCollectionViewCellDelegate {
    func trackerCollectionViewCellDidTapEdit(_ cell: TrackerCollectionViewCell) {
        guard let trackerCellModel = getModelForCell(cell),
              let trackerModel = presenter?.getTracker(with: trackerCellModel.id) else { return }
        
        let trackerFormVC = TrackerFormViewController()
        let presenter = TrackerFormViewPresenter(
            model: trackerModel,
            completedDaysCount: trackerCellModel.completedDaysCount
        )
        presenter.view = trackerFormVC
        trackerFormVC.presenter = presenter
        
        present(trackerFormVC, animated: true)
    }
    
    func trackerCollectionViewCellDidTapDelete(_ cell: TrackerCollectionViewCell) {
        guard let trackerCellModel = getModelForCell(cell) else { return }

        showConfirmationDeleteAlert(for: trackerCellModel.id)
    }
    
    func trackerCollectionViewCell(_ cell: TrackerCollectionViewCell, didTogglePin isPinned: Bool) {
        guard let trackerCellModel = getModelForCell(cell) else { return }
        
        presenter?.setTrackerPinned(isPinned, for: trackerCellModel.id)
    }
    
    func trackerCollectionViewCell(_ cell: TrackerCollectionViewCell, didToggleCompleted isCompleted: Bool) {
        guard let trackerCellModel = getModelForCell(cell) else { return }
        
        presenter?.setTrackerCompleted(isCompleted, for: trackerCellModel.id)
    }
}

// MARK: - Constants
private extension TrackersViewController {
    enum Constants {
        static let addTrackerButtonSize: CGFloat = 42
        static let headerSectionHeight: CGFloat = 34
        static let collectionViewCellHeight: CGFloat = 148
    }
}
