//
//  TrackerQuery.swift
//  Tracker
//
//  Created by Kislov Vadim on 22.05.2026.
//

import Foundation

struct TrackerQuery {
    let date: Date
    let search: String
    
    init(date: Date, search: String = "") {
        self.date = date
        self.search = search
    }
}
