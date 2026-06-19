//
//  StatisticsService.swift
//  Tracker
//
//  Created by Kislov Vadim on 19.06.2026.
//

import Foundation

final class StatisticsService: StatisticsServiceProtocol {
    static let shared = StatisticsService()
    
    private(set) var statistics: StatisticsModel = StatisticsModel(
        bestStreak: 0,
        perfectDays: 0,
        completedTrackers: 0,
        averagePerDay: 0
    )
    
    // MARK: - Private properties
    private lazy var trackerRecordStore = TrackerRecordStore()
    
    private init() {
        calculateStatistics()
    }
    
    // MARK: - Public properties
    func calculateStatistics() {
        let bestStreak = trackerRecordStore.getBestCompletionsStreak()
        let perfectDays = trackerRecordStore.getPerfectDaysCount()
        let completedTrackers = trackerRecordStore.getAllCompletionsCount()
        let averagePerDay = trackerRecordStore.getAverageCompletionsCount()
                
        statistics = StatisticsModel(
            bestStreak: bestStreak,
            perfectDays: perfectDays,
            completedTrackers: completedTrackers,
            averagePerDay: averagePerDay)
    }
}
