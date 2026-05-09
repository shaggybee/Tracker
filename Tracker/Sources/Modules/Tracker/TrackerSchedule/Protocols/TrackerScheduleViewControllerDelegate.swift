//
//  TrackerScheduleViewControllerDelegate.swift
//  Tracker
//
//  Created by Kislov Vadim on 08.05.2026.
//

import Foundation

protocol TrackerScheduleViewControllerDelegate: AnyObject {
    func trackerScheduleViewController(_ vc: TrackerScheduleViewController, didFinishWith selectedDays: Weekdays)
}
