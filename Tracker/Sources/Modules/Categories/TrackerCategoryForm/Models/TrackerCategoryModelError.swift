//
//  TrackerCategoryModelError.swift
//  Tracker
//
//  Created by Kislov Vadim on 06.06.2026.
//

import Foundation

enum TrackerCategoryModelError: Error {
    case empty
    case longString(Int)
    
    var localizedDescription: String {
        switch self {
        case .empty: 
            return NSLocalizedString(L10n.Errors.emptyName, comment: "")
        case .longString(let count):
            return String.localizedStringWithFormat(
                NSLocalizedString(L10n.Validation.lengthLimit, comment: ""),
                count
            )
        }
    }
}
