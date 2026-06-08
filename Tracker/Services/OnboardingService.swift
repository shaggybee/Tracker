//
//  OnboardingService.swift
//  Tracker
//
//  Created by Kislov Vadim on 03.06.2026.
//

import Foundation

final class OnboardingService {
    // MARK: - Static properties
    static let shared = OnboardingService()
    
    // MARK: - Nested Types
    private enum ServiceKeys: String {
        case isOnboarded
    }
    
    // MARK: - Private Properties
    private let storage: UserDefaults = .standard

    // MARK: - Initializers
    private init() { }
}

// MARK: - OnboardingServiceProtocol
extension OnboardingService: OnboardingServiceProtocol {
    var isOnboarded: Bool {
        set {
            storage.setValue(newValue, forKey: ServiceKeys.isOnboarded.rawValue)
        }
        get {
            storage.bool(forKey: ServiceKeys.isOnboarded.rawValue)
        }
    }
}
