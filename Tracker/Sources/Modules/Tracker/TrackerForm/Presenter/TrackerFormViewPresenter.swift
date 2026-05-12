//
//  TrackerFormViewPresenter.swift
//  Tracker
//
//  Created by Kislov Vadim on 08.05.2026.
//

import Foundation

final class TrackerFormViewPresenter: TrackerFormViewPresenterProtocol {
    // MARK: - Public properties
    weak var view: TrackerFormViewControllerProtocol?
    
    var trackerOptions: [TrackerOptionType] {
        trackerType == .habit ? [.category, .schedule] : [.category]
    }
    
    var trackerFormTitle: String {
        trackerType == .habit ? Constants.newHabitTitle : Constants.newIrregularEventTitle
    }
    
    // MARK: - Private properties
    private var trackerType: TrackerType
    private(set) var selectedDays: Weekdays = []
    private(set) var trackerName: String = ""
    
    private var isTrackerNameInvalid: Bool = false
    private var canSaveTracker: Bool {
        guard !isTrackerNameInvalid,
              !trackerName.isEmpty else {
            return false
        }

        switch trackerType {
        case .habit:
            return !selectedDays.isEmpty

        case .irregularEvent:
            return true
        }
    }
    
    // MARK: - Initializers
    init(trackerType: TrackerType) {
        self.trackerType = trackerType
    }
    
    // MARK: - Public methods
    func viewDidLoad() {
        isTrackerNameInvalid = false
        
        view?.setSubmitButtonEnabled(canSaveTracker)
    }
    
    func didChangeSelectedDays(_ selectedDays: Weekdays) {
        self.selectedDays = selectedDays

        view?.setDescription(for: .schedule, with: selectedDays.joinedShortNames)
        view?.setSubmitButtonEnabled(canSaveTracker)
    }
    
    func didChangeTrackerName(_ trackerName: String) {
        if trackerName.count > Constants.trackerNameMaxLength {
            if (!isTrackerNameInvalid) {
                isTrackerNameInvalid = true
                
                view?.setTrackerNameFieldError(Constants.trackerNameError)
            }
        } else if isTrackerNameInvalid {
            isTrackerNameInvalid = false
            
            view?.setTrackerNameFieldError(nil)
        }
        
        self.trackerName = trackerName
        
        view?.setSubmitButtonEnabled(canSaveTracker)
    }
    
    func getTrackerModel() -> Tracker {
        Tracker(
            id: UUID(),
            name: trackerName,
            colorHex: nil,
            emoji: nil,
            type: trackerType,
            schedule: selectedDays)
    }
}

// MARK: - Constants
private extension TrackerFormViewPresenter {
    enum Constants {
        static let trackerNameMaxLength = 38
        
        static let newHabitTitle = "Новая привычка"
        static let newIrregularEventTitle = "Новое нерегулярное событие"
        static let trackerNameError = "Ограничение \(trackerNameMaxLength) символов"
    }
}
