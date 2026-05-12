//
//  TrackerScheduleTableViewCellDelegate.swift
//  Tracker
//
//  Created by Kislov Vadim on 08.05.2026.
//

protocol TrackerScheduleTableViewCellDelegate: AnyObject {
    func trackerScheduleCell(_ cell: TrackerScheduleTableViewCell, didChange isWeekdaySelected: Bool)
}
