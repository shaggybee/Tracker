//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Kislov Vadim on 20.06.2026.
//

import AppMetricaCore

final class AnalyticsService {
    // MARK: Nested types
    private enum AppMetricaEventParameter: String {
        case screen
        case item
    }
    
    // MARK: - Static properties
    static let shared = AnalyticsService()
    
    // MARK: - Private properties
    private lazy var logger = AppLogger.shared
    
    // MARK: - Initializers
    private init() {}
}

// MARK: - AnalyticsServiceProtocol
extension AnalyticsService: AnalyticsServiceProtocol {
    func report(with model: AnalyticsModel) {
        var parameters: [String: String] = [
            AppMetricaEventParameter.screen.rawValue: model.screen.rawValue
        ]
        
        if let item = model.item?.rawValue {
            parameters[AppMetricaEventParameter.item.rawValue] = item
        }
        
        AppMetrica.reportEvent(
            name: model.event.rawValue,
            parameters: parameters,
            onFailure: { [weak self] error in
                self?.logger.error("[AnalyticsService] Failed to report event '\(model.event.rawValue)': \(error.localizedDescription)")
            }
        )
    }
}
