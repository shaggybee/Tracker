//
//  TrackerStoreProtocol.swift
//  Tracker
//
//  Created by Kislov Vadim on 20.05.2026.
//

import Foundation

protocol TrackerStoreProtocol {
    func fetchGroupedTrackers(for trackerQuery: TrackerQuery) throws -> [TrackerCategory]
    func addTracker(tracker: Tracker, for category: String)
    func getTracker(by trackerId: UUID) throws -> TrackerCoreData?
    func getTrackerCompletionstCount(for trackerId: UUID) throws -> Int
}
