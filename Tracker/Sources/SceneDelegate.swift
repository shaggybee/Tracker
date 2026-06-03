//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Kislov Vadim on 01.05.2026.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Public properties
    var window: UIWindow?
    
    private let onboardingService = OnboardingService.shared
    
    // MARK: - UIWindowSceneDelegate
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        setupWindow(with: scene)
    }
    
    // MARK: - Private Methods
    private func setupWindow(with windowScene: UIWindowScene) {
        let window = UIWindow(windowScene: windowScene)
        
        if onboardingService.isOnboarded {
            window.rootViewController = TabBarController()
        } else {
            onboardingService.isOnboarded = true
            
            let vc = OnboardingPageViewController(
                transitionStyle: .scroll,
                navigationOrientation: .horizontal)
            
            vc.didCompleteOnboarding = {
                window.rootViewController = TabBarController()
            }
            
            window.rootViewController = vc
        }
        
        window.makeKeyAndVisible()
        
        self.window = window
    }
}
