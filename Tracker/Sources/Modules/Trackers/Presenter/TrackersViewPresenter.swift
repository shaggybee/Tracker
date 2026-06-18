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
    var searchQuery: String = ""
    var currentFilter: TrackersFilter {
        set {
            trackersFilterService.filter = newValue
        }
        get {
            trackersFilterService.filter
        }
    }
    
    var isFilterApplied: Bool {
        currentFilter == .completed || currentFilter == .unfinished
    }
    
    // MARK: - Private properties
    private lazy var trackerRecordStore = TrackerRecordStore()
    private lazy var trackerStore = TrackerStore()
    private var trackersFilterService: TrackersFilterServiceProtocol
    
    // MARK: - Initializers
    init(trackersFilterService: TrackersFilterServiceProtocol  = TrackersFilterService.shared) {
        self.trackersFilterService = trackersFilterService
    }
    
    // MARK: - Public methods
    func viewDidLoad() {
        trackerStore.delegate = self
        
        trackerStore.loadTrackers(for: getTrackerQueryModel())
    }
    
    func setDate(_ selectedDate: Date) {
        self.selectedDate = selectedDate
        
        trackerStore.loadTrackers(for: getTrackerQueryModel())
    }
    
    func setFilter(_ filter: TrackersFilter) {
        if filter == currentFilter { return }
        
        currentFilter = filter
        
        switch filter {
        case .all:
            setDate(selectedDate)
        case .allForToday:
            selectedDate = Date()
            
            view?.setDate(selectedDate)
            
            setDate(selectedDate)
        default:
            trackerStore.loadTrackers(for: getTrackerQueryModel())
        }
    }
    
    func setTrackerCompleted(_ isCompleted: Bool, for trackerId: UUID) {
        if isCompleted {
            trackerRecordStore.completeTracker(with: trackerId, for: selectedDate)
        } else {
            trackerRecordStore.uncompleteTracker(with: trackerId, for: selectedDate)
        }
    }
    
    func deleteTracker(with id: UUID) {
        trackerStore.deleteTracker(with: id)
    }
    
    func setTrackerPinned(_ isPinned: Bool, for id: UUID) {
        trackerStore.setPinned(isPinned, for: id)
    }
    
    func getTracker(with id: UUID) -> Tracker? {
        trackerStore.getTracker(with: id)
    }
    
    func searchTrackers(with query: String){
        searchQuery = query
        
        trackerStore.loadTrackers(for: getTrackerQueryModel())
    }
    
    // MARK: - Private methods
    private func buildAndPresent(trackerSections: [TrackerCategory]) {
        if trackerSections.isEmpty || trackerSections.allSatisfy({ $0.trackers.isEmpty }) {
            view?.apply(TrackersCollectionModel(sections: []))
            
            let emptyStateModel = searchQuery.isEmpty && !isFilterApplied
            ? EmptyStateModel(
                text: NSLocalizedString(L10n.Trackers.emptyState, comment: ""),
                image: .emptyState
            )
            : EmptyStateModel(
                text: NSLocalizedString(L10n.Other.searchEmptyState, comment: ""),
                image: .searchEmptyState
            )
            
            view?.setEmptyState(with: emptyStateModel)
            view?.setFilterAvailability(isFilterApplied)
            
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
        view?.setEmptyState(with: nil)
        view?.setFilterAvailability(true)
    }
    
    private func prepareModel(for tracker: Tracker) -> TrackerCellModel {
        let completedDaysCount: Int = trackerRecordStore.getCompletionsCount(for: tracker.id)
        
        return TrackerCellModel(
            id: tracker.id,
            name: tracker.name,
            emoji: tracker.emoji,
            colorHex: tracker.colorHex,
            completedDaysCount: completedDaysCount,
            isPinned: tracker.isPinned,
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
    
    private func getTrackerQueryModel() -> TrackerQuery {
        TrackerQuery(
            date: selectedDate,
            search: searchQuery,
            filter: currentFilter
        )
    }
}

// MARK: - TrackerStoreDelegate
extension TrackersViewPresenter: TrackerStoreDelegate {
    func trackerStore(_ store: TrackerStore, didUpdateTrackersSections trackerSections: [TrackerCategory]) {
        buildAndPresent(trackerSections: trackerSections)
    }
}

