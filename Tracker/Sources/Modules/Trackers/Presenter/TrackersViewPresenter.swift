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
    
    var categories: [TrackerCategory] = [TrackerCategory(name: Constants.defaultCategoryName, trackers: [])]
    var completedTrackers: [TrackerRecord] = []
    var selectedDate: Date = Date()
    
    var isAllCategoriesEmpty: Bool {
        categories.isEmpty || categories.allSatisfy({ $0.trackers.isEmpty })
    }
    
    // MARK: - Public methods
    func viewDidLoad() {
        updateViewModel()
    }
    
    func addTracker(_ tracker: Tracker) {
        guard let index = categories.firstIndex(where: { $0.name == Constants.defaultCategoryName }),
              let trackerCategory = categories[safe: index] else { return }
        
        let updatedCategory = TrackerCategory(
            name: trackerCategory.name,
            trackers: trackerCategory.trackers + [tracker]
        )
        
        categories[index] = updatedCategory
        
        updateViewModel()
    }
    
    func setDate(_ selectedDate: Date) {
        self.selectedDate = selectedDate
        
        updateViewModel()
    }
    
    func setTrackerCompleted(_ isCompleted: Bool, for trackerId: UUID) {
        if isCompleted {
            completedTrackers.append(TrackerRecord(trackerId: trackerId, date: selectedDate))
        } else {
            completedTrackers.removeAll { $0.trackerId == trackerId && Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
        }
        
        updateViewModel()
    }
    
    // MARK: - Private methods
    private func updateViewModel() {
        if isAllCategoriesEmpty {
            view?.updateViewModel(TrackersCollectionViewModel(sections: []))
            view?.setEmptyStateVisible(true)
            
            return
        }
        
        let sections: [TrackersSectionViewModel] = categories
            .map { category in
                let name = category.name
                
                let trackers = category.trackers
                    .filter(shouldShow)
                    .map(prepareViewModel)
                
                return TrackersSectionViewModel(
                    name: name,
                    trackers: trackers)
            }
            .filter { !$0.trackers.isEmpty }
        
        view?.updateViewModel(TrackersCollectionViewModel(sections: sections))
        view?.setEmptyStateVisible(sections.isEmpty)
    }
    
    private func shouldShow(tracker: Tracker) -> Bool {
        let currentWeekday = Weekdays.getWeekday(for: selectedDate)
        
        if tracker.type == .habit {
            return tracker.schedule.contains(currentWeekday)
        }
        
        // Проверяем статус выполнения нерегулярного события
        guard let completionInfo = completedTrackers.first(where: { $0.trackerId == tracker.id }) else {
            return true
        }
        
        return Calendar.current.isDate(completionInfo.date, inSameDayAs: selectedDate)
    }
    
    private func prepareViewModel(for tracker: Tracker) -> TrackerViewModel {
        return TrackerViewModel(
            id: tracker.id,
            name: tracker.name,
            emoji: tracker.emoji,
            // TODO в одном из следующих спринтов добавить передачу выбранного цвета (сейчас хардкод из фигмы)
            color: UIColor(
                red: 51.0 / 255.0,
                green: 207.0 / 255.0,
                blue: 105.0 / 255.0,
                alpha: 1.0
            ),
            completedDaysCount: getCompletedDaysCount(for: tracker.id),
            availableAction: getAvailableAction(for: tracker),
        )
    }
    
    private func getCompletedDaysCount(for trackerId: UUID) -> Int {
        return completedTrackers.count { $0.trackerId == trackerId}
    }
    
    private func getAvailableAction(for tracker: Tracker) -> TrackerAvailableAction {
        // Если выбранная дата в будущем, то у привычки нельзя изменить статус выполнения
        if (Calendar.current.compare(selectedDate, to: Date(), toGranularity: .day) == .orderedDescending) {
            return .none
        }
        
        let isCompleted = completedTrackers.contains {
            $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }
        
        return isCompleted ? .uncomplete : .complete
    }
}

// MARK: - TrackersViewPresenter
private extension TrackersViewPresenter {
    enum Constants {
        // TODO удалить в одном из следующих спринтов (после реализации категорий)
        static let defaultCategoryName = "Тестовая"
    }
}
