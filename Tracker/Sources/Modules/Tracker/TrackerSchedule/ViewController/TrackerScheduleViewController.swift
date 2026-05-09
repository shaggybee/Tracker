//
//  TrackerScheduleViewController.swift
//  Tracker
//
//  Created by Kislov Vadim on 08.05.2026.
//

import UIKit

final class TrackerScheduleViewController: UIViewController, TrackerScheduleViewControllerProtocol {
    // MARK: - Public properties
    var presenter: TrackerScheduleViewPresenterProtocol?
    
    weak var delegate: TrackerScheduleViewControllerDelegate?
    
    // MARK: - Private properties   
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = Font.medium16
        label.text = Constants.title
        
        return label
    }().forAutoLayout
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .background
        tableView.layer.cornerRadius = Radius.size16
        tableView.separatorInset = UIEdgeInsets(
            top: 0,
            left: Spacing.space16,
            bottom: 0,
            right: Spacing.space16)
        tableView.separatorColor = .ypGray
        
        return tableView
    }().forAutoLayout
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(Constants.submitButtonText, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = Radius.size16
        button.addTarget(
            self,
            action: #selector(didTapSubmitButton(_:)),
            for: .touchUpInside)
        
        return button
    }().forAutoLayout
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElements()
    }
    
    // MARK: - Private methods
    private func setElements() {
        configTable()
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(submitButton)
        
        setupConstraints()
    }
    
    private func configTable() {
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            TrackerScheduleTableViewCell.self,
            forCellReuseIdentifier: TrackerScheduleTableViewCell.reuseIdentifier)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Spacing.space28),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.space30),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: submitButton.topAnchor, constant: -Spacing.space16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space16),
            tableView.heightAnchor.constraint(equalToConstant: Constants.cellHeight * CGFloat(Weekdays.orderedDays.count)),
            
            submitButton.heightAnchor.constraint(equalToConstant: Constants.submitButtonHeight),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space20),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space20),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Spacing.space16)
        ])
    }
    
    @objc private func didTapSubmitButton(_ sender: UIButton) {
        delegate?.trackerScheduleViewController(self, didFinishWith: presenter?.selectedDays ?? [])
    }
}

// MARK: - UITableViewDataSource
extension TrackerScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.orderedDays.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TrackerScheduleTableViewCell.reuseIdentifier,
            for: indexPath)
        
        guard let cell = cell as? TrackerScheduleTableViewCell,
              let day = presenter.orderedDays[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        if indexPath.row == presenter.orderedDays.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        
        cell.delegate = self
        
        let selectedDays = presenter.selectedDays
        
        cell.configure(with: day.fullName, isWeekdaySelected: selectedDays.contains(day))
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TrackerScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}

// MARK: - TrackerScheduleTableViewCellDelegate
extension TrackerScheduleViewController: TrackerScheduleTableViewCellDelegate {
    func trackerScheduleCell(_ cell: TrackerScheduleTableViewCell, didChange isWeekdaySelected: Bool) {
        guard let indexPath = tableView.indexPath(for: cell),
              let day = presenter?.orderedDays[safe: indexPath.row] else { return }
        
        presenter?.setDaySelected(day, isSelected: isWeekdaySelected)
    }
}

// MARK: - Constants
private extension TrackerScheduleViewController {
    enum Constants {
        static let submitButtonHeight: CGFloat = 60
        static let cellHeight: CGFloat = 75
        
        static let title = "Расписание"
        static let submitButtonText = "Готово"
    }
}

