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
            return "Название не может быть пустым"
        case .longString(let count):
            return "Ограничение - \(count) символов"
        }
    }
}
