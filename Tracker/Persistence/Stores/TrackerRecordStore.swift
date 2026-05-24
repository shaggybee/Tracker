//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Kislov Vadim on 20.05.2026.
//

import CoreData

final class TrackerRecordStore: TrackerRecordStoreProtocol {
    // MARK: - Private properties
    private let context: NSManagedObjectContext
    private lazy var calendar = Calendar.current
    private lazy var logger = AppLogger.shared
    
    // MARK: - Initializers
    convenience init() {
        self.init(context: PersistenceService.shared.context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public methods
    func completeTracker(with trackerId: UUID, for date: Date) {
        guard let tracker = getTracker(by: trackerId) else {
            return
        }
        
        let trackerRecord = TrackerRecordCoreData(context: context)
        
        trackerRecord.trackerId = trackerId
        trackerRecord.date = date
        trackerRecord.tracker = tracker
    
        do {
            try context.save()
        } catch {
            logger.error("[TrackerRecordStore.completeTracker] Failed to mark the tracker as completed with ID \(trackerId). Error: \(error.localizedDescription)")
        }
    }
    
    func uncompleteTracker(with trackerId: UUID, for date: Date) {
        do {
            guard let fetchRequest = makeCompletionFetchRequest(trackerId: trackerId, for: date),
                  let trackerRecord = try context.fetch(fetchRequest).first else { return }
            
            context.delete(trackerRecord)
            
            try context.save()
        } catch {
            logger.error("[TrackerRecordStore.uncompleteTracker] Failed to mark the tracker as uncompleted with ID \(trackerId). Error: \(error.localizedDescription)")
        }
    }
    
    func getCompletionsCount(for trackerId: UUID) -> Int {
        let tracker = getTracker(by: trackerId)
        
        return tracker?.completions?.count ?? 0
    }
    
    func checkCompletion(with trackerId: UUID, for date: Date) -> Bool? {
        guard let fetchRequest = makeCompletionFetchRequest(trackerId: trackerId, for: date) else {
            return nil
        }
        
        do {
            return try context.fetch(fetchRequest).first != nil
        } catch {
            logger.error("[TrackerRecordStore.checkCompletion] Failed to check the tracker completion status with ID \(trackerId). Error: \(error.localizedDescription)")
            
            return nil
        }
    }
    
    // MARK: - Private methods
    private func makeCompletionFetchRequest(trackerId: UUID, for date: Date) -> NSFetchRequest<TrackerRecordCoreData>? {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        let startOfDate = calendar.startOfDay(for: date)
        
        guard let nextDay = calendar.date(byAdding: .day, value: 1, to: startOfDate) else {
            return nil
        }
        
        fetchRequest.predicate = NSPredicate(
            format: "trackerId == %@ AND date >= %@ AND date < %@",
            trackerId as CVarArg,
            startOfDate as CVarArg,
            nextDay as CVarArg)
        
        return fetchRequest
    }
    
    private func getTracker(by trackerId: UUID) -> TrackerCoreData? {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerId as CVarArg)
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            logger.error("[TrackerRecordStore.getTracker] Failed to get tracker with ID \(trackerId). Error: \(error.localizedDescription)")
            
            return nil
        }
    }
}
