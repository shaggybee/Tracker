//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Kislov Vadim on 20.05.2026.
//

import CoreData

final class TrackerRecordStore: TrackerRecordStoreProtocol {
    private let context: NSManagedObjectContext
    
    private lazy var trackerStore = TrackerStore()
    private lazy var calendar = Calendar.current
    
    convenience init() {
        self.init(context: PersistenceService.shared.context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func completeTracker(with trackerId: UUID, for date: Date) throws {
        guard let tracker = try trackerStore.getTracker(by: trackerId) else {
            // TODO подумать что делать
            return
        }
        
        let completion = TrackerRecordCoreData(context: context)
        
        completion.trackerId = trackerId
        completion.date = date
        completion.tracker = tracker
        
        try context.save()
    }
    
    func uncompleteTracker(with trackerId: UUID, for date: Date) throws {
        let trackerRecordRequest = TrackerRecordCoreData.fetchRequest()
        
        let startOfDate = calendar.startOfDay(for: date)
        guard let nextDay = calendar.date(byAdding: .day, value: 1, to: startOfDate) else {
            return
        }
        
        trackerRecordRequest.predicate = NSPredicate(
            format: "trackerId == %@ AND date >= %@ AND date < %@",
            trackerId as CVarArg,
            startOfDate as CVarArg,
            nextDay as CVarArg)
        
        guard let trackerRecord = try context.fetch(trackerRecordRequest).first else {
            // TODO подумать что делать
            return
        }
        
        context.delete(trackerRecord)
        
        try context.save()
    }
}
