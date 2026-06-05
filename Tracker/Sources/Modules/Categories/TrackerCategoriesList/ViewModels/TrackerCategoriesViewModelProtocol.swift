//
//  TrackerCategoriesViewModelProtocol.swift
//  Tracker
//
//  Created by Kislov Vadim on 04.06.2026.
//

import Foundation

protocol TrackerCategoriesViewModelProtocol {
    var categories: [String] { get set }
    var onCategoriesLoaded: (() -> Void)? { get set }
    func loadCategories()
    func isSelected(category: String) -> Bool
}
