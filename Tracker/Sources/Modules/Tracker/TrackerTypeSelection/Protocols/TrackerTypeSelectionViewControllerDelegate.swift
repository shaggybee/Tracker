//
//  TrackerTypeSelectionViewControllerDelegate.swift
//  Tracker
//
//  Created by Kislov Vadim on 05.05.2026.
//

import Foundation

protocol TrackerTypeSelectionViewControllerDelegate: AnyObject {
    func trackerTypeSelectionViewController(_ vc: TrackerTypeSelectionViewController, didSelect type: TrackerType)
}
