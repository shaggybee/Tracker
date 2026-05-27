//
//  TrackerStoreDelegate.swift
//  Tracker
//
//  Created by Kislov Vadim on 23.05.2026.
//

import Foundation

protocol TrackerStoreDelegate: AnyObject {
    func trackerStore(_ store: TrackerStore, didUpdateTrackersSections sections: [TrackerCategory])
}
