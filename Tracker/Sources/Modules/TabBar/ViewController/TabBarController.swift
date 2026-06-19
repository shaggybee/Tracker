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
        appearance.backgroundColor = .ypWhite
        
        tabBar.standardAppearance = appearance
        tabBar.tintColor = .ypBlue
        
        if #unavailable(iOS 26.0) {
            addTopBorder()
        }
        
        let trackersViewPresenter = TrackersViewPresenter()
        let trackersViewController = TrackersViewController()
        
        trackersViewPresenter.view = trackersViewController
        trackersViewController.presenter = trackersViewPresenter
        
        trackersViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString(L10n.Trackers.title, comment: ""),
            image: UIImage(resource: .recordCircleFill),
            selectedImage: nil)
        
        let statisticsViewController = StatisticsViewController()
        
        statisticsViewController.initialize(viewModel: StatisticsViewModel())
        
        statisticsViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString(L10n.Statistics.title, comment: ""),
            image: UIImage(resource: .hareFill),
            selectedImage: nil)
        
        viewControllers = [trackersViewController, statisticsViewController]
    }
    
    private func addTopBorder() {
        let topLine = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        topLine.backgroundColor = .black.withAlphaComponent(0.3)
        
        tabBar.addSubview(topLine)
    }
}
