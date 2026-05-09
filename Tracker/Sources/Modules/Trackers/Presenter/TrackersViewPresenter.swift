//
//  TrackersViewPresenter.swift
//  Tracker
//
//  Created by Kislov Vadim on 09.05.2026.
//

import Foundation

final class TrackersViewPresenter: TrackersViewPresenterProtocol {
    weak var view: TrackersViewControllerProtocol?
    
    var categories: [TrackerCategory] = [TrackerCategory(name: Constants.defaultCategoryName, trackers: [])]
    var completedTrackers: [TrackerRecord] = []
    var selectedDate: Date = Date()
    
    func viewDidLoad() {
        view?.showEmptyState()
    }
    
    func addTracker(_ tracker: Tracker) {
        guard let index = categories.firstIndex(where: { $0.name == Constants.defaultCategoryName }),
              let trackerCategory = categories[safe: index] else { return }
        
        let updatedCategory = TrackerCategory(
            name: trackerCategory.name,
            trackers: trackerCategory.trackers + [tracker]
        )
        
        categories[index] = updatedCategory
    }
    
    func setDate(_ selectedDate: Date) {
        self.selectedDate = selectedDate
    }
}

private extension TrackersViewPresenter {
    enum Constants {
        // TODO удалить в одном из следующих спринтов (после реализации категорий)
        static let defaultCategoryName = "Тестовая"
    }
}
