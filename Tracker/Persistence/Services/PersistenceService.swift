//
//  PersistenceService.swift
//  Tracker
//
//  Created by Kislov Vadim on 20.05.2026.
//

import CoreData

final class PersistenceService: PersistenceServiceProtocol {
    static let shared = PersistenceService()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.containerName)
        
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                print("Load Persistent Store failed: \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context: NSManagedObjectContext = container.viewContext
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
                context.rollback()
            }
        }
    }
}

private extension PersistenceService {
    enum Constants {
        static let containerName: String = "Tracker"
    }
}
