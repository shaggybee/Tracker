//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Kislov Vadim on 20.05.2026.
//

import CoreData

final class TrackerCategoryStore: TrackerCategoryStoreProtocol {
    private let context: NSManagedObjectContext
    
    convenience init() {
        self.init(context: PersistenceService.shared.context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getCategory(by name: String) throws -> TrackerCategoryCoreData? {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        return try context.fetch(fetchRequest).first
    }
    
    func createCategory(with name: String) throws {
        guard try getCategory(by: name) == nil else { return }
        
        let category = TrackerCategoryCoreData(context: context)
        category.name = name
        
        try context.save()
    }
}
