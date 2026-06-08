//
//  TrackerCategoryStoreProtocol.swift
//  Tracker
//
//  Created by Kislov Vadim on 20.05.2026.
//

import Foundation

protocol TrackerCategoryStoreProtocol {
    var delegate: TrackerCategoryStoreDelegate? { get set }
    func loadCategories()
    func createCategory(with name: String) throws
    func updateCategory(with name: String, by newName: String) throws
    func deleteCategory(with name: String) throws
}
