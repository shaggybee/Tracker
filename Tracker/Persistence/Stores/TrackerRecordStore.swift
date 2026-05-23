//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Kislov Vadim on 20.05.2026.
//

import CoreData

final class TrackerRecordStore: TrackerRecordStoreProtocol {
    private let context: NSManagedObjectContext
    
    private lazy var calendar = Calendar.current
    
    convenience init() {
        self.init(context: PersistenceService.shared.context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func completeTracker(with trackerId: UUID, for date: Date) throws {
        guard let tracker = try getTracker(by: trackerId) else {
            // TODO подумать что делать
            return
        }
        
        let trackerRecord = TrackerRecordCoreData(context: context)
        
        trackerRecord.trackerId = trackerId
        trackerRecord.date = date
        trackerRecord.tracker = tracker
        
        try context.save()
    }
    
    func uncompleteTracker(with trackerId: UUID, for date: Date) throws {
        guard let fetchRequest = makeCompletionFetchRequest(trackerId: trackerId, for: date) else {
            return
        }
        
        guard let trackerRecord = try context.fetch(fetchRequest).first else {
            // TODO подумать что делать
            return
        }
        
        context.delete(trackerRecord)
        
        try context.save()
    }
    
    func getCompletionsCount(for trackerId: UUID) throws -> Int {
        let tracker = try getTracker(by: trackerId)
        
        return tracker?.completions?.count ?? 0
    }
    
    func checkCompletion(with trackerId: UUID, for date: Date) throws -> Bool? {
        guard let fetchRequest = makeCompletionFetchRequest(trackerId: trackerId, for: date) else {
            return nil
        }

        return try context.fetch(fetchRequest).first != nil
    }
    
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
    
    private func getTracker(by trackerId: UUID) throws -> TrackerCoreData? {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerId as CVarArg)
        
        return try context.fetch(fetchRequest).first
    }
}
