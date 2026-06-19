//
//  StatisticsModel.swift
//  Tracker
//
//  Created by Kislov Vadim on 18.06.2026.
//

import Foundation

struct StatisticsModel {
    let bestStreak: Int
    let perfectDays: Int
    let completedTrackers: Int
    let averagePerDay: Int
    
    var isEmpty: Bool {
        bestStreak == 0 &&
        perfectDays == 0 &&
        completedTrackers == 0 &&
        averagePerDay == 0
    }
}
