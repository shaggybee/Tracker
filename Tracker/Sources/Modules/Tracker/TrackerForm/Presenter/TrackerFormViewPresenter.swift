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
    private(set) var categoryName: String?
    private(set) var selectedEmoji: String?
    private(set) var selectedColorHex: String?
    
    private var isTrackerNameInvalid: Bool = false
    private var canSaveTracker: Bool {
        guard !isTrackerNameInvalid,
              !trackerName.isEmpty,
              !(categoryName ?? "").isEmpty,
              let _ = selectedEmoji,
              let _ = selectedColorHex
        else { return false }

        switch trackerType {
        case .habit:
            return !selectedDays.isEmpty
        case .irregularEvent:
            return true
        }
    }

    private lazy var trackerStore = TrackerStore()
    private lazy var logger = AppLogger.shared
    
    // MARK: - Initializers
    init(trackerType: TrackerType) {
        self.trackerType = trackerType
    }
    
    // MARK: - Public methods
    func viewDidLoad() {
        isTrackerNameInvalid = false
        
        view?.setSubmitButtonEnabled(canSaveTracker)
        
        buildAndPresentTrackerAppearance()
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
    
    func didChangeTrackerCategory(_ categoryName: String?) {
        self.categoryName = categoryName
        
        view?.setDescription(for: .category, with: categoryName ?? "")
        view?.setSubmitButtonEnabled(canSaveTracker)
    }
    
    func getTrackerModel() -> Tracker? {
        guard let selectedColorHex, let selectedEmoji, let categoryName, !categoryName.isEmpty else {
            return nil
        }
        
        return Tracker(
            id: UUID(),
            name: trackerName,
            colorHex: selectedColorHex,
            emoji: selectedEmoji,
            type: trackerType,
            categoryName: categoryName,
            schedule: selectedDays)
    }
    
    func didChangeSelectedEmoji(_ emoji: String) {
        selectedEmoji = emoji
        
        view?.setSubmitButtonEnabled(canSaveTracker)
        
        buildAndPresentTrackerAppearance()
    }
    
    func didChangeSelectedColor(_ colorHex: String) {
        selectedColorHex = colorHex
        
        view?.setSubmitButtonEnabled(canSaveTracker)
        
        buildAndPresentTrackerAppearance()
    }
    
    func createTracker() {
        guard let tracker = getTrackerModel() else {
            return
        }
        
        trackerStore.addTracker(tracker)
    }
    
    // MARK: - Private methods
    private func buildAndPresentTrackerAppearance() {
        let emojiItems: [TrackerAppearanceItem] = TrackerConstants.emojis.map { emoji in
            let model = TrackerEmojiCellModel(
                emoji: emoji,
                isSelected: emoji == selectedEmoji)
            
            return .emoji(model: model)
        }
        
        
        let colorItems: [TrackerAppearanceItem] = TrackerConstants.hexColors.map { colorHex in
            let model = TrackerColorCellModel(
                colorHex: colorHex,
                isSelected: colorHex == selectedColorHex)
            
            return .color(model: model)
        }
        
        let sections: [TrackerAppearanceSectionModel] = [
            TrackerAppearanceSectionModel(name: "Emoji", items: emojiItems),
            TrackerAppearanceSectionModel(name: "Цвет", items: colorItems)
        ]
        
        view?.apply(TrackerAppearanceCollectionModel(sections: sections))
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
