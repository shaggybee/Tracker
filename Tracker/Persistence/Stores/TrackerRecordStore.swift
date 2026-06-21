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
        guard let tracker = getTracker(by: trackerId), checkCompletion(with: trackerId, for: date) == false else {
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
    
    func getPerfectDaysCount() -> Int {
        guard let habitRecords = getHabitRecords(),
              let habitTrackers = getHabitTrackers(),
              !habitRecords.isEmpty,
              !habitTrackers.isEmpty else { return 0 }
        
        var trackersPerWeekday: [Weekdays: Int] = [:]
        
        for tracker in habitTrackers {
            let schedule = Weekdays(rawValue: tracker.schedule)

            for weekday in Weekdays.orderedDays where schedule.contains(weekday) {
                trackersPerWeekday[weekday, default: 0] += 1
            }
        }
        
        var recordsPerDay: [Date: Int] = [:]
        
        for record in habitRecords {
            guard let date = record.date else { continue }
            
            recordsPerDay[calendar.startOfDay(for: date), default: 0] += 1
        }
        
        var perfectDays: Int = 0
        
        for (date, completedCount) in recordsPerDay {
            let weekday = Weekdays.getWeekday(for: date)

            if completedCount == trackersPerWeekday[weekday] {
                perfectDays += 1
            }
        }
        
        return perfectDays
    }
    
    func getBestCompletionsStreak() -> Int {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        do {
            let records = try context.fetch(fetchRequest)
            
            guard !records.isEmpty else { return 0 }
            
            let dates = records
                .compactMap(\.date)
                .map(calendar.startOfDay)
            
            let uniqDates = Set(dates).sorted()
            
            guard !uniqDates.isEmpty else { return 0 }
            
            var bestSeries = 0
            var currentSeries = 0
            var previousDate: Date?
            
            uniqDates.forEach { date in
                if let previousDate, calendar.dateComponents([.day], from: previousDate, to: date).day == 1 {
                    currentSeries += 1
                } else {
                    currentSeries = 1
                }
                
                bestSeries = max(bestSeries, currentSeries)
                previousDate = date
            }
            
            return bestSeries
        } catch {
            logger.error("[TrackerRecordStore.getBestCompletionsStreak] Failed to get best period. Error: \(error.localizedDescription)")
            
            return 0
        }
    }
    
    func getAllCompletionsCount() -> Int {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        do {
            let count = try context.fetch(fetchRequest).count
            
            return count
        } catch {
            logger.error("[TrackerRecordStore.getAllCompletionsCount] Failed to get all completions count. Error: \(error.localizedDescription)")
            
            return 0
        }
    }
    
    func getAverageCompletionsCount() -> Int {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        do {
            let records = try context.fetch(fetchRequest)
            
            guard !records.isEmpty else { return 0 }
            
            let dates = records
                .compactMap(\.date)
                .map(calendar.startOfDay)
            
            let uniqDates = Set(dates)
            
            guard !uniqDates.isEmpty else { return 0 }
            
            return records.count / uniqDates.count
        } catch {
            logger.error("[TrackerRecordStore.getAverageCompletionsCount] Failed to get average completions count. Error: \(error.localizedDescription)")
            
            return 0
        }
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
    
    private func getHabitRecords() -> [TrackerRecordCoreData]? {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "tracker.type == %@", TrackerType.habit.rawValue)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            logger.error("[TrackerRecordStore.getHabitRecords] Failed to get records for trackers with type habit. Error: \(error.localizedDescription)")
            
            return nil
        }
    }
    
    private func getHabitTrackers() -> [TrackerCoreData]? {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "type == %@", TrackerType.habit.rawValue)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            logger.error("[TrackerRecordStore.getHabitTrackers] Failed to get trackers with type habit. Error: \(error.localizedDescription)")
            
            return nil
        }
    }
}
