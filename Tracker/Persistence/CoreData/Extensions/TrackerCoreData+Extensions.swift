//
//  TrackerCoreData+Extensions.swift
//  Tracker
//
//  Created by Kislov Vadim on 22.05.2026.
//

import Foundation

extension TrackerCoreData {    
    @objc var sectionIdentifier: String {
        pinned ? TrackerCategoryStore.Constants.categoryNameReserved : categoryName ?? ""
    }
}
