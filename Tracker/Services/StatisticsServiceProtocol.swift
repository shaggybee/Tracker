//
//  StatisticsServiceProtocol.swift
//  Tracker
//
//  Created by Kislov Vadim on 19.06.2026.
//

import Foundation

protocol StatisticsServiceProtocol {
    var statistics: StatisticsModel { get }
    func calculateStatistics()
}
