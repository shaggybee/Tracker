//
//  TrackersFilterService.swift
//  Tracker
//
//  Created by Kislov Vadim on 17.06.2026.
//

import Foundation

final class TrackersFilterService {
    // MARK: - Static properties
    static let shared = TrackersFilterService()
    
    // MARK: - Nested Types
    private enum ServiceKeys: String {
        case trackersFilter
    }
    
    // MARK: - Private Properties
    private let storage: UserDefaults = .standard

    // MARK: - Initializers
    private init() { }
}

// MARK: - OnboardingServiceProtocol
extension TrackersFilterService: TrackersFilterServiceProtocol {
    var filter: TrackersFilter {
        set {
            let value = newValue == .allForToday ? TrackersFilter.all.rawValue : newValue.rawValue
            
            storage.setValue(value, forKey: ServiceKeys.trackersFilter.rawValue)
        }
        get {
            let rawValue = storage.string(forKey: ServiceKeys.trackersFilter.rawValue)
            
            return TrackersFilter(rawValue: rawValue ?? "") ?? .all
        }
    }
}
