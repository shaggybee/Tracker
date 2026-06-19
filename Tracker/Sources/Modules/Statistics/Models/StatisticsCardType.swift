//
//  StatisticsCardType.swift
//  Tracker
//
//  Created by Kislov Vadim on 19.06.2026.
//

import Foundation

enum StatisticsCardType: CaseIterable {
    case bestStreak
    case perfectDays
    case completedTrackers
    case averagePerDay
    
    var title: String {
        switch self {
            case .bestStreak: NSLocalizedString(L10n.Statistics.bestStreak, comment: "")
            case .perfectDays: NSLocalizedString(L10n.Statistics.perfectDays, comment: "")
            case .completedTrackers: NSLocalizedString(L10n.Statistics.completedTrackers, comment: "")
            case .averagePerDay: NSLocalizedString(L10n.Statistics.averagePerDay, comment: "")
        }
    }
}
