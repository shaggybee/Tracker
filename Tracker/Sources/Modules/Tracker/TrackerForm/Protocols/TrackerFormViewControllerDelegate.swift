//
//  TrackerFormViewControllerDelegate.swift.swift
//  Tracker
//
//  Created by Kislov Vadim on 05.05.2026.
//

import Foundation

protocol TrackerFormViewControllerDelegate: AnyObject {
    func trackerFormViewController(_ vc: TrackerFormViewController, didCreateTracker tracker: Tracker)
}
