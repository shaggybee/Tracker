//
//  TabBarController.swift
//  Tracker
//
//  Created by Kislov Vadim on 02.05.2026.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTabBar()
    }
    
    // MARK: - Private methods
    private func configTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        tabBar.standardAppearance = appearance
        tabBar.tintColor = .ypBlue
        
        addTopBorder()
        
        let trackersViewController = TrackersViewController()
        let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
        trackersViewController.tabBarItem = UITabBarItem(
            title: Constants.trackersBarItemTitle,
            image: UIImage(resource: .recordCircleFill),
            selectedImage: nil)
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: Constants.statisticsBarItemTitle,
            image: UIImage(resource: .hareFill),
            selectedImage: nil)
        
        viewControllers = [trackersNavigationController, statisticsViewController]
    }
    
    private func addTopBorder() {
        let topLine = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        topLine.backgroundColor = .ypLightGray
        
        tabBar.addSubview(topLine)
    }
}

private extension TabBarController {
    enum Constants {
        static let statisticsBarItemTitle = "Статистика"
        static let trackersBarItemTitle = "Трекеры"
    }
}
