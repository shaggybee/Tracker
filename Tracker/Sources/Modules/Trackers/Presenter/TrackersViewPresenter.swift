//
//  TrackersViewPresenter.swift
//  Tracker
//
//  Created by Kislov Vadim on 09.05.2026.
//

import UIKit

final class TrackersViewPresenter: TrackersViewPresenterProtocol {
    
    // MARK: - Public properties
    weak var view: TrackersViewControllerProtocol?
    
    var completedTrackers: [TrackerRecord] = []
    var selectedDate: Date = Date()
    
    private lazy var trackerRecordStore = TrackerRecordStore()
    private lazy var trackerStore = TrackerStore()
    
    // MARK: - Public methods
    func viewDidLoad() {
        trackerStore.delegate = self
        
        trackerStore.loadTrackers(for: TrackerQuery(date: selectedDate))
    }
    
    func setDate(_ selectedDate: Date) {
        self.selectedDate = selectedDate
        
        trackerStore.loadTrackers(for: TrackerQuery(date: selectedDate))
    }
    
    func setTrackerCompleted(_ isCompleted: Bool, for trackerId: UUID) {
        if isCompleted {
            trackerRecordStore.completeTracker(with: trackerId, for: selectedDate)
        } else {
            trackerRecordStore.uncompleteTracker(with: trackerId, for: selectedDate)
        }
    }
    
    // MARK: - Private methods
    private func buildAndPresent(trackerSections: [TrackerCategory]) {
        if trackerSections.isEmpty || trackerSections.allSatisfy({ $0.trackers.isEmpty }) {
            view?.apply(TrackersCollectionModel(sections: []))
            view?.setEmptyStateVisible(true)
            
            return
        }
        
        let sections: [TrackersSectionModel] = trackerSections
            .map { trackerSection in
                let name = trackerSection.name
                
                let trackers = trackerSection.trackers
                    .map(prepareModel)
                
                return TrackersSectionModel(
                    name: name,
                    trackers: trackers)
            }
        
        view?.apply(TrackersCollectionModel(sections: sections))
        view?.setEmptyStateVisible(sections.isEmpty)
    }
    
    private func prepareModel(for tracker: Tracker) -> TrackerCellModel {
        let completedDaysCount: Int = trackerRecordStore.getCompletionsCount(for: tracker.id)
        
        return TrackerCellModel(
            id: tracker.id,
            name: tracker.name,
            emoji: tracker.emoji,
            colorHex: tracker.colorHex,
            completedDaysCount: completedDaysCount,
            availableAction: getAvailableAction(for: tracker.id),
        )
    }

    private func getAvailableAction(for trackerId: UUID) -> TrackerAvailableAction {
        // Если выбранная дата в будущем, то у привычки нельзя изменить статус выполнения
        if (Calendar.current.compare(selectedDate, to: Date(), toGranularity: .day) == .orderedDescending) {
            return .none
        }
        
        guard let isCompleted = trackerRecordStore.checkCompletion(with: trackerId, for: selectedDate) else {
            return .none
        }
        
        return isCompleted ? .uncomplete : .complete
    }
}

// MARK: - TrackerStoreDelegate
extension TrackersViewPresenter: TrackerStoreDelegate {
    func trackerStore(_ store: TrackerStore, didUpdateTrackersSections trackerSections: [TrackerCategory]) {
        buildAndPresent(trackerSections: trackerSections)
    }
}

