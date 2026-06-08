//
//  TrackerCategoryFormViewModel.swift
//  Tracker
//
//  Created by Kislov Vadim on 05.06.2026.
//

import Foundation

final class TrackerCategoryFormViewModel: TrackerCategoryFormViewModelProtocol {
    
    // MARK: - Public properties
    var isSaveEnabled: Bool { model.isValidName(categoryName) }
    var title: String { isEditMode ? Constants.editCategoryTitle : Constants.createCategoryTitle }
    
    var onSaveEnabledChanged: Binding<Bool>?
    var onCategoryNameErrorChanged: Binding<String?>?
    var onSaveFailed: Binding<String?>?
    var onSaveCompleted: Binding<String>?
    
    let isEditMode: Bool
    
    // MARK: Private properties
    private var trackerCategoryStore: TrackerCategoryStoreProtocol?
    
    private(set) var categoryName: String
    private let model: TrackerCategoryFormModel
    
    // MARK: - Initializers
    convenience init(model: TrackerCategoryFormModel) {
        self.init(model: model, trackerCategoryStore: TrackerCategoryStore())
    }
    
    init(model: TrackerCategoryFormModel, trackerCategoryStore: TrackerCategoryStoreProtocol) {
        self.model = model
        self.trackerCategoryStore = trackerCategoryStore
        
        categoryName = model.categoryName ?? ""
        isEditMode = !categoryName.isEmpty
    }
    
    // MARK: Public methods
    func save() {
        do {
            if isEditMode {
                try trackerCategoryStore?.updateCategory(with: model.categoryName ?? "", by: categoryName)
            } else {
                try trackerCategoryStore?.createCategory(with: categoryName)
            }
            
            onSaveCompleted?(categoryName)
        } catch let error {
            guard let error = error as? TrackerCategoryStoreError else {
                return
            }
            
            onSaveFailed?(error.errorDescription ?? "")
        }
    }
    
    func didChange(text: String) {
        categoryName = text
        
        let result = model.didEnter(text)
        
        switch result {
        case .success:
            onSaveEnabledChanged?(true)
            onCategoryNameErrorChanged?(nil)
        case .failure(let error):
            onSaveEnabledChanged?(false)
            
            guard let error = error as? TrackerCategoryModelError, case .longString = error else {
                onCategoryNameErrorChanged?(nil)
                return
            }
            
            onCategoryNameErrorChanged?(error.localizedDescription)
        }
    }
}

// MARK: - Constants
private extension TrackerCategoryFormViewModel {
    enum Constants {
        static let createCategoryTitle = "Новая категория"
        static let editCategoryTitle = "Редактирование категории"
    }
}
