//
//  AppDelegate.swift
//  Tracker
//
//  Created by Kislov Vadim on 01.05.2026.
//

import UIKit
import AppMetricaCore

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - UIApplicationDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureAppMetrica()
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }
    
    // MARK: - Private methods
    private func configureAppMetrica() {
        if let configuration = AppMetricaConfiguration(apiKey: AnalyticsConstants.apiMetricaKey) {
            AppMetrica.activate(with: configuration)
        }
    }
}
