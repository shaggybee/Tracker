//
//  TrackersFilter.swift
//  Tracker
//
//  Created by Kislov Vadim on 17.06.2026.
//

import Foundation

enum TrackersFilter: String, CaseIterable {
    case all
    case allForToday
    case completed
    case unfinished
    
    var description: String? {
        switch self {
        case .all: NSLocalizedString(L10n.Trackers.Filters.all, comment: "")
        case .allForToday: NSLocalizedString(L10n.Trackers.Filters.allForToday, comment: "")
        case .completed: NSLocalizedString(L10n.Trackers.Filters.completed, comment: "")
        case .unfinished: NSLocalizedString(L10n.Trackers.Filters.unfinished, comment: "")
        }
    }
}
