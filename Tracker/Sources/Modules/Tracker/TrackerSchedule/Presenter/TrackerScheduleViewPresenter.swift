//
//  TrackerScheduleViewPresenter.swift
//  Tracker
//
//  Created by Kislov Vadim on 09.05.2026.
//

import Foundation

final class TrackerScheduleViewPresenter: TrackerScheduleViewPresenterProtocol {

    // MARK: - Public properties
    weak var view: TrackerScheduleViewControllerProtocol?
    
    var selectedDays: Weekdays = []
    var orderedDays: [Weekdays] { Weekdays.orderedDays }
    
    // MARK: - Initializers
    init(selectedDays: Weekdays) {
        self.selectedDays = selectedDays
    }

    // MARK: - Public methods
    func setDaySelected(_ day: Weekdays, isSelected: Bool) {
        if isSelected {
            selectedDays.insert(day)
        } else {
            selectedDays.remove(day)
        }
    }
}
