//
//  TrackerStore.swift
//  Tracker
//
//  Created by Kislov Vadim on 20.05.2026.
//

import CoreData

final class TrackerStore: NSObject, TrackerStoreProtocol {
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    
    // MARK: - Inits
    convenience override init() {
        self.init(context: PersistenceService.shared.context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
        
        super.init()
    }
    
    // MARK: - Public methods
    func fetchGroupedTrackers(for trackerQuery: TrackerQuery) throws -> [TrackerCategory] {
        buildFetchedResultsController(for: trackerQuery)
        
        guard let fetchedResultsController else { return [] }
        
        try fetchedResultsController.performFetch()
        
        // TODO добавить формирование данных из секций
        
        return []
    }
    
    func addTracker(tracker: Tracker, for category: String) {
        // TODO добавление трекера
        
        // TODO добавить группу через отдельный стор если нужно
    }
    
    func getTrackerCompletionstCount(for trackerId: UUID) throws -> Int {
        let tracker = try getTracker(by: trackerId)
        
        return tracker?.completions?.count ?? 0
    }
    
    func getTracker(by trackerId: UUID) throws -> TrackerCoreData? {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerId as CVarArg)
        
        let result = try context.fetch(fetchRequest)
        
        return result.first
    }
    
    // MARK: - Private methods
    private func buildFetchedResultsController(for trackerQuery: TrackerQuery? = nil) {
        let resultsController = NSFetchedResultsController(
            fetchRequest: getTrackerFetchRequest(),
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(TrackerCoreData.sectionIdentifier),
            cacheName: nil)
        
        resultsController.delegate = self
        
        fetchedResultsController = resultsController
    }
    
    private func getTrackerFetchRequest(for date: Date = Date.now) -> NSFetchRequest<TrackerCoreData> {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.category?.name, ascending: true)
        ]
        
        // TODO добавить фильтрацию элементов
        
        return fetchRequest
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    
}
