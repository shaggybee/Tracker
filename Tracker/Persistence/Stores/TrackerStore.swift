//
//  TrackerStore.swift
//  Tracker
//
//  Created by Kislov Vadim on 20.05.2026.
//

import CoreData

final class TrackerStore: NSObject, TrackerStoreProtocol {
    // MARK: - Public properties
    weak var delegate: TrackerStoreDelegate?
    
    // MARK: - Private properties
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    
    private lazy var calendar = Calendar.current
    private lazy var logger = AppLogger.shared
    
    // MARK: - Initializers
    convenience override init() {
        self.init(context: PersistenceService.shared.context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
        
        super.init()
    }
    
    // MARK: - Public methods
    func loadTrackers(for trackerQuery: TrackerQuery) {
        buildFetchedResultsController(for: trackerQuery)
        
        guard let fetchedResultsController else { return }
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            logger.error("[TrackerStore.loadTrackers] Failed to load trackers. Error: \(error.localizedDescription)")
            
            return
        }
        
        let sections = transformResultsControllerSections()
        
        delegate?.trackerStore(self, didUpdateTrackersSections: sections)
    }
    
    func addTracker(_ tracker: Tracker, for categoryName: String) {
        do {
            guard let category = try findCategory(by: categoryName) else {
                return
            }
            
            let newTracker = prepareTrackerCoreData(from: tracker, for: context)
            
            category.addToTrackers(newTracker)
            
            try context.save()
        } catch {
            logger.error("[TrackerStore.addTracker] Failed to add tracker. Error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Private methods
    private func findCategory(by name: String) throws -> TrackerCategoryCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.fetchLimit = 1
        
        return try context.fetch(fetchRequest).first
    }
    
    private func buildFetchedResultsController(for trackerQuery: TrackerQuery) {
        guard let fetchRequest = getTrackerFetchRequest(for: trackerQuery) else {
            return
        }
        
        let resultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(TrackerCoreData.sectionIdentifier),
            cacheName: nil)
        
        resultsController.delegate = self
        
        fetchedResultsController = resultsController
    }
    
    private func getTrackerFetchRequest(for trackerQuery: TrackerQuery) -> NSFetchRequest<TrackerCoreData>? {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.category?.name, ascending: true),
            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)
        ]
        
        // Фильтруем события по следующему принципу:
        // тип "привычка" - возвращаем, если день недели (текущая выбранная дана) включен в расписание;
        // тип "нерегулярное событие" - возвращаем, если событие не выполнено или было выполнено и дата
        // выполнения соответствует текущей
        
        let selectedDate = trackerQuery.date
        let weekday = Weekdays.getWeekday(for: selectedDate).rawValue
        
        let startOfDate = calendar.startOfDay(for: selectedDate)
        
        guard let nextDay = calendar.date(byAdding: .day, value: 1, to: startOfDate) else {
            return nil
        }
        
        let habitsEventPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "type == %@", TrackerType.habit.rawValue),
            NSPredicate(format: "(schedule & %d) > 0", weekday)
        ])
        
        let completionIrregularEventPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "completions.@count == 0"),
            NSPredicate(
                format: "SUBQUERY(completions, $c, $c.date >= %@ AND $c.date < %@).@count > 0",
                startOfDate as CVarArg,
                nextDay as NSDate)
        ])
        
        let irregularEventPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "type == %@", TrackerType.irregularEvent.rawValue),
            completionIrregularEventPredicate
        ])
        
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            habitsEventPredicate,
            irregularEventPredicate
        ])

        return fetchRequest
    }
    
    private func prepareTrackerCoreData(from model: Tracker, for context: NSManagedObjectContext) -> TrackerCoreData {
        let tracker = TrackerCoreData(context: context)
        
        tracker.id = model.id
        tracker.name = model.name
        tracker.colorHex = model.colorHex
        tracker.emoji = model.emoji
        tracker.type = model.type.rawValue
        tracker.schedule = model.schedule.rawValue
        
        return tracker
    }
    
    private func transformResultsControllerSections() -> [TrackerCategory] {
        guard let sections = fetchedResultsController?.sections else {
            return []
        }

        return sections.compactMap { section in
            guard let objects = section.objects as? [TrackerCoreData] else {
                return nil
            }
            
            let trackers: [Tracker] = objects.compactMap(transformTrackerCoreData)
            
            return TrackerCategory(name: section.name, trackers: trackers)
        }
    }
    
    private func transformTrackerCoreData(_ trackerCoreData: TrackerCoreData) -> Tracker? {
        guard let id = trackerCoreData.id,
              let name = trackerCoreData.name,
              let colorHex = trackerCoreData.colorHex,
              let emoji = trackerCoreData.emoji,
              let type = TrackerType(rawValue: trackerCoreData.type ?? "") else { return nil }
        
        return Tracker(
            id: id,
            name: name,
            colorHex: colorHex,
            emoji: emoji,
            type: type,
            schedule: Weekdays(rawValue: trackerCoreData.schedule))
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        let trackerSections = transformResultsControllerSections()
        
        delegate?.trackerStore(self, didUpdateTrackersSections: trackerSections)
    }
}
