//
//  TrackerCategoryStoreProtocol.swift
//  Tracker
//
//  Created by Kislov Vadim on 20.05.2026.
//

import Foundation

protocol TrackerCategoryStoreProtocol {
    func getCategory(by name: String) throws -> TrackerCategoryCoreData?
    func createCategory(with name: String) throws
}
