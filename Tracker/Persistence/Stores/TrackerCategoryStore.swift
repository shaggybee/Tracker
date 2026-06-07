//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Kislov Vadim on 20.05.2026.
//

import CoreData

final class TrackerCategoryStore: NSObject, TrackerCategoryStoreProtocol {
    
    // MARK: - Public properies
    var delegate: TrackerCategoryStoreDelegate?
    
    // MARK: - Private properties
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?
    
    private lazy var logger = AppLogger.shared
    
    // MARK: - Initializers
    convenience override init() {
        self.init(context: PersistenceService.shared.context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        super.init()
        
        self.buildFetchedResultsController()
    }
    
    // MARK: - Public methods
    func createCategory(with name: String) throws {
        if let _ = try getCategory(with: name) {
            logger.info("[TrackerCategoryStore.updateCategory] Name for category not uniq")
            
            throw TrackerCategoryStoreError.duplicateName
        }
        
        let category = TrackerCategoryCoreData(context: context)
        category.name = name
        
        try context.save()
    }
    
    func updateCategory(with name: String, by newName: String) throws {
        if name == newName || newName.isEmpty {
            return
        }
        
        do {
            if let _ = try getCategory(with: newName) {
                logger.info("[TrackerCategoryStore.updateCategory] Name for category not uniq")
                
                throw TrackerCategoryStoreError.duplicateName
            }
            
            guard let category = try getCategory(with: name) else {
                logger.info("[TrackerCategoryStore.updateCategory] Not found category with name - \(name)")
                
                throw TrackerCategoryStoreError.categoryNotFound
            }
            
            category.name = newName
            
            guard let trackers = category.trackers as? Set<TrackerCoreData> else { return }
            
            trackers.forEach { tracker in
                tracker.categoryName = newName
            }
            
            try context.save()
        } catch {
            logger.error("[TrackerCategoryStore.updateCategory] Failed to update category. Error: \(error.localizedDescription)")
            
            throw error
        }
    }
    
    func deleteCategory(with name: String) throws {
        do {
            guard let category = try getCategory(with: name) else {
                logger.info("[TrackerCategoryStore.deleteCategory] Not found category with name - \(name)")
                
                throw TrackerCategoryStoreError.categoryNotFound
            }
            
            context.delete(category)
            
            try context.save()
        } catch {
            logger.error("[TrackerCategoryStore.deleteCategory] Failed to delete category. Error: \(error.localizedDescription)")
            
            throw error
        }
    }
    
    func loadCategories() {
        guard let fetchedResultsController else { return }
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            logger.error("[TrackerCategoryStore.loadCategories] Failed to load categories. Error: \(error.localizedDescription)")
            
            return
        }
    
        delegate?.trackerCategoryStore(self, didUpdateTrackersCategories: prepareCategories())
    }
    
    // MARK: - Private methods
    private func getCategory(with name: String) throws -> TrackerCategoryCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.fetchLimit = 1
        
        return try context.fetch(fetchRequest).first
    }
    
    private func buildFetchedResultsController() {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.name, ascending: true)
        ]
        
        let resultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        resultsController.delegate = self
        
        fetchedResultsController = resultsController
    }
    
    private func prepareCategories() -> [String] {
        guard let categories = fetchedResultsController?.fetchedObjects else {
            return []
        }
        
        let preparedCategories: [String] = categories.compactMap { category in
            guard let name = category.name, !name.isEmpty else { return nil }
            
            return name
        }
        
        return preparedCategories
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>){
        delegate?.trackerCategoryStore(self, didUpdateTrackersCategories: prepareCategories())
    }
}
