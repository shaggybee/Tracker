//
//  TrackersViewModels.swift
//  Tracker
//
//  Created by Kislov Vadim on 09.05.2026.
//

import UIKit

struct TrackersSectionViewModel {
    let name: String
    let trackers: [TrackerViewModel]
}

struct TrackersCollectionViewModel {
    let sections: [TrackersSectionViewModel]
}

struct TrackerViewModel {
    let id: UUID
    let name: String
    let emoji: String?
    let color: UIColor
    let completedDaysCount: Int
    let availableAction: TrackerAvailableAction
}
