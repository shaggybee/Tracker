//
//  TrackerRecordStoreProtocol.swift
//  Tracker
//
//  Created by Kislov Vadim on 20.05.2026.
//

import Foundation

protocol TrackerRecordStoreProtocol {
    func completeTracker(with trackerId: UUID, for date: Date)
    func uncompleteTracker(with trackerId: UUID, for date: Date)
    func getCompletionsCount(for trackerId: UUID) -> Int
    func checkCompletion(with trackerId: UUID, for date: Date) -> Bool?
}
