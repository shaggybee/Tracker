//
//  CoreErrors.swift
//  Tracker
//
//  Created by Kislov Vadim on 05.06.2026.
//

import Foundation

enum TrackerCategoryStoreError: LocalizedError {
    case duplicateName
    case categoryNotFound
    
    var errorDescription: String? {
        switch self {
        case .duplicateName: "Категория с таким названием уже существует"
        case .categoryNotFound: "Категория не найдена"
        }
    }
}
