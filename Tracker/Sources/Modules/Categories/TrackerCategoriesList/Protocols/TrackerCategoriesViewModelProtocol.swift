//
//  TrackerCategoriesViewModelProtocol.swift
//  Tracker
//
//  Created by Kislov Vadim on 04.06.2026.
//

import Foundation

protocol TrackerCategoriesViewModelProtocol {
    var categories: [String] { get set }
    var isCategoriesEmpty: Bool { get }
    var onCategoriesLoaded: Completion? { get set }
    var onShowCategoryForm: Binding<TrackerCategoryFormViewModel>? { get set }
    var onCategoryChanged: Binding<String?>? { get set }
    
    func loadCategories()
    func didSelectCategory(_ categoryName: String)
    func didUpdateCategory(with name: String, by newName: String)
    func didTapCreateCategory()
    func didTapUpdateCategory(with name: String)
    func deleteCategory(with name: String)
    func isSelected(category: String) -> Bool
}
