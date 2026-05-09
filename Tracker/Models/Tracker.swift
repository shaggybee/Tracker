//
//  Tracker.swift
//  Tracker
//
//  Created by Kislov Vadim on 04.05.2026.
//

import Foundation

struct Tracker {
    let id: UUID
    let name: String
    let colorHex: String?
    let emoji: String?
    let type: TrackerType
    let schedule: Weekdays
}
