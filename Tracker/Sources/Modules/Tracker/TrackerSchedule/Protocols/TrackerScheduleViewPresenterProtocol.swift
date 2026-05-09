//
//  TrackerScheduleViewPresenterProtocol.swift
//  Tracker
//
//  Created by Kislov Vadim on 08.05.2026.
//

import Foundation

protocol TrackerScheduleViewPresenterProtocol {
    var view: TrackerScheduleViewControllerProtocol? { get set }
    var selectedDays: Weekdays { get }
    var orderedDays: [Weekdays] { get }
    func setDaySelected(_ day: Weekdays, isSelected: Bool)
}
