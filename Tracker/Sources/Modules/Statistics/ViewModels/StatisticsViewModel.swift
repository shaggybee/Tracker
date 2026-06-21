//
//  StatisticsViewModel.swift
//  Tracker
//
//  Created by Kislov Vadim on 19.06.2026.
//

import Foundation

final class StatisticsViewModel: StatisticsViewModelProtocol {
    
    // MARK: - Public properties
    var onStatisticsChanged: Binding<StatisticsModel?>?
 
    // MARK: - Private properties
    private var statisticsService: StatisticsServiceProtocol
    
    // MARK: - Initializers
    init(statisticsService: StatisticsServiceProtocol = StatisticsService.shared) {
        self.statisticsService = statisticsService
    }
    
    // MARK: - Public methods
    func recalculateStatistics() {
        if statisticsService.statistics.isEmpty {
            onStatisticsChanged?(nil)
        } else {
            onStatisticsChanged?(statisticsService.statistics)
        }
    }
}
