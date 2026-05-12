//
//  TrackerScheduleTableViewCell.swift
//  Tracker
//
//  Created by Kislov Vadim on 06.05.2026.
//

import UIKit

final class TrackerScheduleTableViewCell: UITableViewCell {
    // MARK: - Static properties
    static let reuseIdentifier = "TrackerScheduleTableViewCell"
    
    // MARK: - Public properties
    weak var delegate: TrackerScheduleTableViewCellDelegate?
    
    // MARK: - Private properties
    private lazy var weekdayLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .ypBlack
        label.font = Font.regular17
        
        return label
    }().forAutoLayout
    
    private lazy var cellStackView: UIStackView = {
        let stack = UIStackView()
        
        stack.spacing = Spacing.space16
        stack.axis = .horizontal
        stack.distribution = .fill
        
        return stack
    }().forAutoLayout
    
    private lazy var daySelectionSwitch: UISwitch = {
        let daySelectionSwitch = UISwitch()
        
        daySelectionSwitch.addTarget(
             self,
             action: #selector(didToggleDaySelection),
             for: .valueChanged
         )
        
        return daySelectionSwitch
    }().forAutoLayout
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setElements()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Public methods
    func configure(with title: String, isWeekdaySelected: Bool) {
        weekdayLabel.text = title
        daySelectionSwitch.isOn = isWeekdaySelected
    }
    
    // MARK: - Private methods
    private func setElements() {
        backgroundColor = .background
        selectionStyle = .none
        
        cellStackView.addArrangedSubview(weekdayLabel)
        cellStackView.addArrangedSubview(daySelectionSwitch)
        
        contentView.addSubview(cellStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.space22),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spacing.space22),
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.space16),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.space16),
        ])
    }
    
    @objc private func didToggleDaySelection() {
        delegate?.trackerScheduleCell(self, didChange: daySelectionSwitch.isOn)
    }
}
