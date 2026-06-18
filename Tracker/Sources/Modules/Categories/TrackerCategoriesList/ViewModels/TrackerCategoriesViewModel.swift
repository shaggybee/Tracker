//
//  TrackerCategoriesViewModel.swift
//  Tracker
//
//  Created by Kislov Vadim on 04.06.2026.
//

import Foundation

final class TrackerCategoriesViewModel: TrackerCategoriesViewModelProtocol {
    
    // MARK: - Public properties
    var categories: [String] = [] {
        didSet {
            onCategoriesLoaded?()
        }
    }
    
    var isCategoriesEmpty: Bool { categories.isEmpty }
    
    let canManageCategories: Bool
    
    var onCategoriesLoaded: Completion?
    var onShowCategoryForm: Binding<TrackerCategoryFormViewModel>?
    var onCategoryChanged: Binding<String?>?
    
    // MARK: Private properties
    private lazy var logger = AppLogger.shared
    private var trackerCategoryStore: TrackerCategoryStoreProtocol?
    
    private var selectedCategory: String?
    
    // MARK: - Initializers
    convenience init(currentCategory: String?, canManageCategories: Bool = true) {
        self.init(
            currentCategory: currentCategory,
            trackerCategoryStore: TrackerCategoryStore(),
            canManageCategories: canManageCategories
        )
    }
    
    init(
        currentCategory: String?,
        trackerCategoryStore: TrackerCategoryStoreProtocol,
        canManageCategories: Bool = true
    ) {
        self.selectedCategory = currentCategory
        self.trackerCategoryStore = trackerCategoryStore
        self.canManageCategories = canManageCategories
        
        self.trackerCategoryStore?.delegate = self
    }
    
    // MARK: - Public properties
    func loadCategories() {
        trackerCategoryStore?.loadCategories()
    }
    
    func isSelected(category: String) -> Bool {
        category == selectedCategory
    }
    
    func didTapCreateCategory() {
        let viewModel = TrackerCategoryFormViewModel(
            model: TrackerCategoryFormModel()
        )
        
        onShowCategoryForm?(viewModel)
    }
    
    func didTapUpdateCategory(with name: String) {
        let viewModel = TrackerCategoryFormViewModel(
            model: TrackerCategoryFormModel(categoryName: name)
        )
        
        onShowCategoryForm?(viewModel)
    }
    
    func deleteCategory(with name: String) {
        do {
            try trackerCategoryStore?.deleteCategory(with: name)
            
            if name == selectedCategory {
                self.selectedCategory = nil
                
                onCategoryChanged?(self.selectedCategory)
            }
        } catch {
            logger.error("[TrackerCategoriesViewModel.deleteCategory] Failed to delete category with name \(name). Error: \(error.localizedDescription)")
        }
    }
    
    func didSelectCategory(_ categoryName: String) {
        self.selectedCategory = categoryName
        
        onCategoryChanged?(categoryName)
    }
    
    func didUpdateCategory(with name: String, by newName: String) {
        if selectedCategory != name || name == newName { return }
        
        selectedCategory = newName
        
        onCategoryChanged?(self.selectedCategory)
    }
}

// MARK: - TrackerCategoryStoreDelegate
extension TrackerCategoriesViewModel: TrackerCategoryStoreDelegate {
    func trackerCategoryStore(_ store: TrackerCategoryStore, didUpdateTrackersCategories categories: [String]) {
        self.categories = categories
    }
}
