//
//  PersistenceService.swift
//  Tracker
//
//  Created by Kislov Vadim on 20.05.2026.
//

import CoreData

final class PersistenceService {
    static let shared = PersistenceService()
    
    // MARK: - Public properties
    lazy var context: NSManagedObjectContext = container.viewContext
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.containerName)
        
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                assertionFailure("Load Persistent Store failed \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

// MARK: - Constants
private extension PersistenceService {
    enum Constants {
        static let containerName: String = "Tracker"
    }
}
