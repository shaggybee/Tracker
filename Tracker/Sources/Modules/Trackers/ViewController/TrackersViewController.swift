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
    private var trackersCollectionViewModel: TrackersCollectionViewModel = TrackersCollectionViewModel(sections: [])
    
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
    
    private lazy var titleLable: UILabel = {
        let label = UILabel()
        
        label.font = Font.bold34
        label.textColor = .ypBlack
        label.text = Constants.titleText
        
        return label
    }().forAutoLayout
    
    private lazy var searchBarView: SearchBarView = {
        let textField = SearchBarView()
        
        return textField
    }().forAutoLayout
    
    private lazy var trackersCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        
        collectionViewLayout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        collectionView.isHidden = true
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }().forAutoLayout
    
    private lazy var emptyStateView: EmptyStateView = {
        let emptyStateView = EmptyStateView(text: Constants.emptyStateText)
        
        emptyStateView.isHidden = true
        
        return emptyStateView
    }().forAutoLayout
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElements()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Public methods
    func updateViewModel(_ viewModel: TrackersCollectionViewModel) {
        trackersCollectionViewModel = viewModel
        
        trackersCollectionView.reloadData()
    }
    
    func setEmptyStateVisible(_ isVisible: Bool) {
        emptyStateView.isHidden = !isVisible
        trackersCollectionView.isHidden = isVisible
    }
    
    // MARK: - Private methods
    private func setElements() {
        view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        configNavigationItems()
        configureTrackersCollectionView()

        view.addSubview(titleLable)
        view.addSubview(searchBarView)
        view.addSubview(emptyStateView)
        view.addSubview(trackersCollectionView)
        
        setupConstraints()
    }
    
    private func configureTrackersCollectionView() {
        trackersCollectionView.dataSource = self
        trackersCollectionView.delegate = self
        
        trackersCollectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier)
        
        trackersCollectionView.register(
            TrackerCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCollectionViewHeader.reuseIdentifier)
    }
    
    private func configNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addTrackerButton)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        if #available(iOS 26.0, *) {
            navigationItem.rightBarButtonItem?.hidesSharedBackground = true
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Spacing.separator),
            titleLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Spacing.space16),
            
            searchBarView.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: Spacing.space8),
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space16),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space16),
            
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space16),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space16),
            emptyStateView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            trackersCollectionView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: Spacing.space8),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space16),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space16),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
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
        vc.dismiss(animated: true)
        
        let trackerFormVC = TrackerFormViewController()
        let presenter = TrackerFormViewPresenter(trackerType: type)
        presenter.view = trackerFormVC
        trackerFormVC.delegate = self
        trackerFormVC.presenter = presenter
        
        present(trackerFormVC, animated: true)
    }
}

// MARK: - TrackerFormViewControllerDelegate
extension TrackersViewController: TrackerFormViewControllerDelegate {
    func trackerFormViewController(_ vc: TrackerFormViewController, didCreateTracker tracker: Tracker) {
        presenter?.addTracker(tracker)
        vc.dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackersCollectionViewModel.sections[safe: section]?.trackers.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        trackersCollectionViewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier,
            for: indexPath)
        
        guard let cell = cell as? TrackerCollectionViewCell,
              let cellViewModel = trackersCollectionViewModel.sections[safe: indexPath.section]?.trackers[safe: indexPath.row] else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        cell.configure(with: cellViewModel)
        
        return cell
    }
    
    func collectionView(
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
        
        headerView.configure(with: trackersCollectionViewModel.sections[safe: indexPath.section]?.name ?? "")
        
        return headerView
    }
}

// MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate { }

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: (collectionView.bounds.width / 2) - Spacing.space4, height: Constants.collectionViewCellHeight)
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
    func trackerCollectionViewCell(_ cell: TrackerCollectionViewCell, didToggleCompleted isCompleted: Bool) {
        guard let indexPath = trackersCollectionView.indexPath(for: cell),
              let trackerViewModel = trackersCollectionViewModel.sections[safe: indexPath.section]?.trackers[safe: indexPath.row] else { return }
        
        presenter?.setTrackerCompleted(isCompleted, for: trackerViewModel.id)
    }
}

// MARK: - Constants
private extension TrackersViewController {
    enum Constants {
        static let headerSectionHeight: CGFloat = 46
        static let collectionViewCellHeight: CGFloat = 148
        
        static let titleText = "Трекеры"
        static let emptyStateText = "Что будем отслеживать?"
    }
}
