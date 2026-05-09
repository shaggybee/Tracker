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
    private var trackerOptions: [TrackerOption] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .background
        tableView.layer.cornerRadius = Radius.size16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: Spacing.space16, bottom: 0, right: Spacing.space16)
        tableView.separatorColor = .ypGray
        tableView.isScrollEnabled = false
        
        return tableView
    }().forAutoLayout
    
    init(trackerOptions: [TrackerOption] = []) {
        super.init(frame: .zero)
        
        self.trackerOptions = trackerOptions
        
        setElements()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    func setDescription(for trackerOption: TrackerOption, with text: String) {
        guard let index = trackerOptions.firstIndex(where: { $0 == trackerOption }),
              let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)),
              let cell = cell as? TrackerOptionsTableViewCell else { return }
        
        var config = cell.contentConfiguration as? UIListContentConfiguration
        
        config?.secondaryText = text
        cell.contentConfiguration = config
    }
    
    // MARK: - Private methods
    private func setElements() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            TrackerOptionsTableViewCell.self,
            forCellReuseIdentifier: TrackerOptionsTableViewCell.reuseIdentifier)
        
        addSubview(tableView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * trackerOptions.count))
        ])
    }
}

extension TrackerOptionsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}

extension TrackerOptionsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackerOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TrackerOptionsTableViewCell.reuseIdentifier,
            for: indexPath)
        
        guard let cell = cell as? TrackerOptionsTableViewCell,
              let trackerOption = trackerOptions[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        if indexPath.row == trackerOptions.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        
        var contentConfiguration = cell.contentConfiguration as? UIListContentConfiguration
        
        switch trackerOption {
        case .category:
            contentConfiguration?.text = "Категория"
        case .schedule:
            contentConfiguration?.text = "Расписание"
        }
        
        cell.contentConfiguration = contentConfiguration
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let trackerOption = trackerOptions[safe: indexPath.row] else {
            return
        }
        
        delegate?.trackerOptionsView(self, didSelect: trackerOption)
    }
}
