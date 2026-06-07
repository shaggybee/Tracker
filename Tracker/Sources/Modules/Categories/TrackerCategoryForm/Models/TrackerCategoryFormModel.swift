//
//  TrackerCategoryFormModel.swift
//  Tracker
//
//  Created by Kislov Vadim on 05.06.2026.
//

import Foundation

// MARK: - Constants
private enum Constants {
    static let maxLenght = 38
}

final class TrackerCategoryFormModel {
    // MARK: - Public properties
    let categoryName: String?
    
    // MARK: - Initializers
    init(categoryName: String? = nil) {
        self.categoryName = categoryName
    }
    
    // MARK: Public methods
    func isValidName(_ categoryName: String) -> Bool {
        (1...Constants.maxLenght).contains(categoryName.count)
    }
    
    func didEnter(_ categoryName: String) -> Result<Bool, Error> {
        do {
            try validate(categoryName)
        } catch {
            return .failure(error)
        }

        return .success(true)
    }
    
    // MARK: Private methods
    private func validate(_ categoryName: String) throws {
        if categoryName.isEmpty {
            throw TrackerCategoryModelError.empty
        } else if !isValidName(categoryName) {
            throw TrackerCategoryModelError.longString(Constants.maxLenght)
        }
    }
}
