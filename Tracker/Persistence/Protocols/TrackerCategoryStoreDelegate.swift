//
//  TrackerCategoryStoreDelegate.swift
//  Tracker
//
//  Created by Kislov Vadim on 05.06.2026.
//

import Foundation

protocol TrackerCategoryStoreDelegate: AnyObject {
    func trackerCategoryStore(_ store: TrackerCategoryStore, didUpdateTrackersCategories categories: [String])
}
