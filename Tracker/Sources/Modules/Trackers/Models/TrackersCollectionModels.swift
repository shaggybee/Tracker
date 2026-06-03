//
//  TrackersCollectionModels.swift
//  Tracker
//
//  Created by Kislov Vadim on 09.05.2026.
//

import Foundation

struct TrackersSectionModel {
    let name: String
    let trackers: [TrackerCellModel]
}

struct TrackersCollectionModel {
    let sections: [TrackersSectionModel]
}

struct TrackerCellModel: Hashable, Sendable {
    let id: UUID
    let name: String
    let emoji: String?
    let colorHex: String
    let completedDaysCount: Int
    let availableAction: TrackerAvailableAction
}
