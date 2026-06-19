//
//  StatisticsViewModelProtocol.swift
//  Tracker
//
//  Created by Kislov Vadim on 19.06.2026.
//

protocol StatisticsViewModelProtocol {
    var onStatisticsChanged: Binding<StatisticsModel?>? { get set }
    func recalculateStatistics()
}
