//
//  TrackerStoreProtocol.swift
//  Tracker
//
//  Created by Kislov Vadim on 20.05.2026.
//

import Foundation

protocol TrackerStoreProtocol {
    func loadTrackers(for trackerQuery: TrackerQuery)
    func addTracker(_ tracker: Tracker)
    func updateTracker(_ updatedTracker: Tracker)
    func deleteTracker(with id: UUID)
    func setPinned(_ isPinned: Bool, for id: UUID)
    func getTracker(with id: UUID) -> Tracker?
}
