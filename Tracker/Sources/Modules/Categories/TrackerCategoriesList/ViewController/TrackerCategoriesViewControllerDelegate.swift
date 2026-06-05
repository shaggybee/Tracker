//
//  TrackerCategoriesViewControllerDelegate.swift
//  Tracker
//
//  Created by Kislov Vadim on 05.06.2026.
//

import Foundation

protocol TrackerCategoriesViewControllerDelegate: AnyObject {
    func trackerCategoriesViewController(_ viewController: TrackerCategoriesViewController, didChangeCategoryName categoryName: String?)
}
