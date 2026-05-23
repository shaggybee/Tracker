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
    private lazy var trackerCategoryStore = TrackerCategoryStore()
    private lazy var trackerStore = TrackerStore()
    
    // MARK: - Public methods
    func viewDidLoad() {
        trackerStore.delegate = self
        
        // TODO подумать над try?
        try? trackerStore.loadTrackers(for: TrackerQuery(date: selectedDate))
    }
    
    func addTracker(_ tracker: Tracker) {
        // TODO подумать над try?
        
        // TODO временное решение, удалить в одном из следующих спринтов (после реализации категорий)
        try? trackerCategoryStore.createCategory(with: Constants.defaultCategoryName)
        try? trackerStore.addTracker(tracker, for: Constants.defaultCategoryName)
    }
    
    func setDate(_ selectedDate: Date) {
        self.selectedDate = selectedDate
        
        try? trackerStore.loadTrackers(for: TrackerQuery(date: selectedDate))
    }
    
    func setTrackerCompleted(_ isCompleted: Bool, for trackerId: UUID) {
        // TODO подумать над try?
        if isCompleted {
            try? trackerRecordStore.completeTracker(with: trackerId, for: selectedDate)
        } else {
            try? trackerRecordStore.uncompleteTracker(with: trackerId, for: selectedDate)
        }
    }
    
    // MARK: - Private methods
    private func buildAndPresent(trackerSections: [TrackerCategory]) {
        if trackerSections.isEmpty || trackerSections.allSatisfy({ $0.trackers.isEmpty }) {
            view?.apply(TrackersCollectionViewModel(sections: []))
            view?.setEmptyStateVisible(true)
            
            return
        }
        
        let sections: [TrackersSectionViewModel] = trackerSections
            .map { trackerSection in
                let name = trackerSection.name
                
                let trackers = trackerSection.trackers
                    .map(prepareViewModel)
                
                return TrackersSectionViewModel(
                    name: name,
                    trackers: trackers)
            }
        
        view?.apply(TrackersCollectionViewModel(sections: sections))
        view?.setEmptyStateVisible(sections.isEmpty)
    }
    
    private func prepareViewModel(for tracker: Tracker) -> TrackerViewModel {
        let completedDaysCount: Int? = try? trackerRecordStore.getCompletionsCount(for: tracker.id)
        
        return TrackerViewModel(
            id: tracker.id,
            name: tracker.name,
            emoji: tracker.emoji,
            colorHex: tracker.colorHex,
            completedDaysCount: completedDaysCount ?? 0,
            availableAction: getAvailableAction(for: tracker.id),
        )
    }

    private func getAvailableAction(for trackerId: UUID) -> TrackerAvailableAction {
        // Если выбранная дата в будущем, то у привычки нельзя изменить статус выполнения
        if (Calendar.current.compare(selectedDate, to: Date(), toGranularity: .day) == .orderedDescending) {
            return .none
        }
        
        guard let isCompleted = try? trackerRecordStore.checkCompletion(with: trackerId, for: selectedDate) else {
            return .none
        }
        
        return isCompleted ? .uncomplete : .complete
    }
}

extension TrackersViewPresenter: TrackerStoreDelegate {
    func trackerStore(_ store: TrackerStore, didUpdateTrackersSections trackerSections: [TrackerCategory]) {
        buildAndPresent(trackerSections: trackerSections)
    }
}

// MARK: - TrackersViewPresenter
private extension TrackersViewPresenter {
    enum Constants {
        // TODO удалить в одном из следующих спринтов (после реализации категорий)
        static let defaultCategoryName = "Домашний уют"
    }
}
