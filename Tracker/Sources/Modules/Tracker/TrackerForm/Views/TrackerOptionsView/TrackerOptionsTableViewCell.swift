//
//  TrackerOptionsTableViewCell.swift
//  Tracker
//
//  Created by Kislov Vadim on 06.05.2026.
//

import UIKit

final class TrackerOptionsTableViewCell: UITableViewCell {
    static let reuseIdentifier = "TrackerOptionsTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    private func configure() {
        accessoryType = .disclosureIndicator
        layoutMargins = UIEdgeInsets(top: 0, left: Spacing.space16, bottom: 0, right: Spacing.space16)
        backgroundColor = .background
        selectionStyle = .none
        
        var configuration = UIListContentConfiguration.cell()

        configuration.textProperties.font = Font.regular17
        configuration.textProperties.color = .ypBlack
        configuration.secondaryTextProperties.font = Font.regular17
        configuration.secondaryTextProperties.color = .ypGray
        
        contentConfiguration = configuration
    }
}

