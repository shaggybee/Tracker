//
//  TrackersViewControllerSnapshotTests.swift
//  TrackerTests
//
//  Created by Kislov Vadim on 20.06.2026.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackersViewControllerSnapshotTests: XCTestCase {
    func testTrackersViewControllerForLightTheme() {
        let vc = getTrackersViewController()
        
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testTrackersViewControllerForDarkTheme() {
        let vc = getTrackersViewController()
        
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    
    func getTrackersViewController() -> UIViewController {
        let trackersViewPresenter = TrackersViewPresenter()
        let trackersViewController = TrackersViewController()
        
        trackersViewPresenter.view = trackersViewController
        trackersViewController.presenter = trackersViewPresenter
        
        return trackersViewController
    }
}
