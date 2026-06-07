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
    
    var onCategoriesLoaded: Completion?
    var onShowCategoryForm: Binding<TrackerCategoryFormViewModel>?
    var onCategoryChanged: Binding<String?>?
    
    // MARK: Private properties
    private var selectedCategory: String?
    
    private var trackerCategoryStore: TrackerCategoryStoreProtocol?
    
    // MARK: - Initializers
    convenience init(currentCategory: String?) {
        self.init(currentCategory: currentCategory, trackerCategoryStore: TrackerCategoryStore())
    }
    
    init(currentCategory: String?, trackerCategoryStore: TrackerCategoryStoreProtocol) {
        self.selectedCategory = currentCategory
        self.trackerCategoryStore = trackerCategoryStore
        
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
        } catch {}
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
