//
//  Weekdays.swift
//  Tracker
//
//  Created by Kislov Vadim on 04.05.2026.
//

import Foundation

struct Weekdays: OptionSet {
    let rawValue: Int8
    
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
        case .monday:  "Понедельник"
        case .tuesday: "Вторник"
        case .wednesday: "Среда"
        case .thursday: "Четверг"
        case .friday: "Пятница"
        case .saturday: "Суббота"
        case .sunday: "Воскресенье"
        default: ""
        }
    }
    
    var joinedShortNames: String {
        let filteredDays = Weekdays.orderedDays.filter { self.contains($0) }
        
        return filteredDays.count == Weekdays.orderedDays.count
            ? "Каждый день"
            : filteredDays
                .map { $0.shortName }
                .joined(separator: ", ")
    }
    
    private var shortName: String {
        switch self {
        case .monday:  "Пн"
        case .tuesday: "Вт"
        case .wednesday: "Ср"
        case .thursday: "Чт"
        case .friday: "Пт"
        case .saturday: "Сб"
        case .sunday: "Вс"
        default: ""
        }
    }
}
