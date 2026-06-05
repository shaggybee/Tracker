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
            // TODO добавить проверку и сброс выбранной категории (на случай если категорию удалили)
            
            onCategoriesLoaded?()
        }
    }
    
    var onCategoriesLoaded: (() -> Void)?
    
    // MARK: Private properties
    private var selectedCategory: String?
    
    private var trackerCategoryStore: TrackerCategoryStoreProtocol?
    
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
}

// MARK: - TrackerCategoryStoreDelegate
extension TrackerCategoriesViewModel: TrackerCategoryStoreDelegate {
    func trackerCategoryStore(_ store: TrackerCategoryStore, didUpdateTrackersCategories categories: [String]) {
        self.categories = categories
    }
    
    func trackerCategoryStore(_ store: TrackerCategoryStore, didLoadTrackersCategories categories: [String]) {
        self.categories = categories
    }
}
