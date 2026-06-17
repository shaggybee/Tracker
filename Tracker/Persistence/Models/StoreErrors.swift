//
//  CoreErrors.swift
//  Tracker
//
//  Created by Kislov Vadim on 05.06.2026.
//

import Foundation

enum TrackerCategoryStoreError: LocalizedError {
    case duplicateName
    case nameReserved
    case categoryNotFound
    
    var errorDescription: String? {
        switch self {
        case .nameReserved: NSLocalizedString(L10n.Errors.nameReserved, comment: "")
        case .duplicateName: NSLocalizedString(L10n.Errors.duplicateName, comment: "")
        case .categoryNotFound: NSLocalizedString(L10n.Errors.categoryNotFound, comment: "")
        }
    }
}
