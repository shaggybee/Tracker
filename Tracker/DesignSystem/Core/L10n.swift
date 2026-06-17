//
//  L10n.swift
//  Tracker
//
//  Created by Kislov Vadim on 12.06.2026.
//

import Foundation

enum L10n {
    enum Category {
        static let title = "category.title"
        static let add = "category.add"
        static let new = "category.new"
        static let edit = "category.edit"
        static let emptyState = "category.emptyState"
        static let deleteConfirmation = "category.deleteConfirmation"
        static let enterName = "category.enterName"
    }
    
    enum Tracker {
        static let newHabitTitle = "tracker.newHabitTitle"
        static let editHabitTitle = "tracker.editHabitTitle"
        static let newIrregularEventTitle = "tracker.newIrregularEventTitle"
        static let editIrregularEventTitle = "tracker.editIrregularEventTitle"
        static let nameFieldPlaceholder = "tracker.nameFieldPlaceholder"
        static let createTrackerTitle = "tracker.createTrackerTitle"
        static let deleteConfirmation = "tracker.deleteConfirmation"
    }
    
    enum Trackers {
        static let title = "trackers.title"
        static let emptyState = "trackers.emptyState"
    }
    
    enum Onboarding {
        enum Titles {
            static let trackWhatYouWant = "onboarding.titles.trackWhatYouWant"
            static let notOnlyWaterAndYoga = "onboarding.titles.notOnlyWaterAndYoga"
            static let completionButton = "onboarding.titles.completionButton"
        }
    }
    
    enum Statistics {
        static let title = "statistics.title"
    }
    
    enum Actions {
        static let edit = "actions.edit"
        static let delete = "actions.delete"
        static let cancel = "actions.cancel"
        static let create = "actions.create"
        static let pin = "actions.pin"
        static let unpin = "actions.unpin"
        static let save = "actions.save"
    }
    
    enum Errors {
        static let somethingWrong = "errors.somethingWrong"
        static let emptyName = "errors.emptyName"
        static let nameReserved = "errors.nameReserved"
        static let duplicateName = "errors.duplicateName"
        static let categoryNotFound = "errors.categoryNotFound"
    }
    
    enum Validation {
        static let lengthLimit = "validation.lengthLimit"
    }
    
    enum Other {
        static let ready = "other.ready"
        static let ok = "other.ok"
        static let color = "other.color"
        static let schedule = "other.schedule"
        static let habit = "other.habit"
        static let irregularEvent = "other.irregularEvent"
        static let days = "other.days"
        static let search = "other.search"
        static let searchEmptyState = "other.searchEmptyState"
        static let pinned = "other.pinned"
    }
}
