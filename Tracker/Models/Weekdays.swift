//
//  Weekdays.swift
//  Tracker
//
//  Created by Kislov Vadim on 04.05.2026.
//

import Foundation

struct Weekdays: OptionSet, Hashable {
    let rawValue: Int16
    
    static let sunday = Weekdays(rawValue: 1 << 0)
    static let monday = Weekdays(rawValue: 1 << 1)
    static let tuesday = Weekdays(rawValue: 1 << 2)
    static let wednesday = Weekdays(rawValue: 1 << 3)
    static let thursday = Weekdays(rawValue: 1 << 4)
    static let friday = Weekdays(rawValue: 1 << 5)
    static let saturday = Weekdays(rawValue: 1 << 6)
}

extension Weekdays {
    static let orderedDays: [Weekdays] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    
    static func getWeekday(for date: Date) -> Weekdays {
        let weekday = Calendar.current.component(.weekday, from: date)
        
        return Weekdays(rawValue: 1 << (weekday - 1))
    }
    
    var fullName: String {
        switch self {
        case .monday: NSLocalizedString(L10n.Days.Full.monday, comment: "")
        case .tuesday: NSLocalizedString(L10n.Days.Full.tuesday, comment: "")
        case .wednesday: NSLocalizedString(L10n.Days.Full.wednesday, comment: "")
        case .thursday: NSLocalizedString(L10n.Days.Full.thursday, comment: "")
        case .friday: NSLocalizedString(L10n.Days.Full.friday, comment: "")
        case .saturday: NSLocalizedString(L10n.Days.Full.saturday, comment: "")
        case .sunday: NSLocalizedString(L10n.Days.Full.sunday, comment: "")
        default: ""
        }
    }
    
    var joinedShortNames: String {
        let filteredDays = Weekdays.orderedDays.filter { self.contains($0) }
        
        return filteredDays.count == Weekdays.orderedDays.count
        ? NSLocalizedString(L10n.Days.everyday, comment: "")
            : filteredDays
                .map { $0.shortName }
                .joined(separator: ", ")
    }
    
    private var shortName: String {
        switch self {
        case .monday: NSLocalizedString(L10n.Days.Short.monday, comment: "")
        case .tuesday: NSLocalizedString(L10n.Days.Short.tuesday, comment: "")
        case .wednesday: NSLocalizedString(L10n.Days.Short.wednesday, comment: "")
        case .thursday: NSLocalizedString(L10n.Days.Short.thursday, comment: "")
        case .friday: NSLocalizedString(L10n.Days.Short.friday, comment: "")
        case .saturday: NSLocalizedString(L10n.Days.Short.saturday, comment: "")
        case .sunday: NSLocalizedString(L10n.Days.Short.sunday, comment: "")
        default: ""
        }
    }
}
