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
}
