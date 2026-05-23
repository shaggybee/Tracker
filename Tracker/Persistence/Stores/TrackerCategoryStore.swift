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

    func createCategory(with name: String) throws {
        if let _ = try getCategory(with: name) {
            // TODO в следующем спринте обработать ситуацию когда категория с таким именем существует
            return
        }
        
        let category = TrackerCategoryCoreData(context: context)
        category.name = name
        
        try context.save()
    }
    
    private func getCategory(with name: String) throws -> TrackerCategoryCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.fetchLimit = 1
        
        return try context.fetch(fetchRequest).first
    }
}
