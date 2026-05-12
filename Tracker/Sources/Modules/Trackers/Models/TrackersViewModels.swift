//
//  TrackersViewModels.swift
//  Tracker
//
//  Created by Kislov Vadim on 09.05.2026.
//

import Foundation

struct TrackersSectionViewModel {
    let name: String
    let trackers: [TrackerViewModel]
}

struct TrackersCollectionViewModel {
    let sections: [TrackersSectionViewModel]
}

struct TrackerViewModel: Hashable, Sendable {
    let id: UUID
    let name: String
    let emoji: String?
    let colorHex: String
    let completedDaysCount: Int
    let availableAction: TrackerAvailableAction
}
