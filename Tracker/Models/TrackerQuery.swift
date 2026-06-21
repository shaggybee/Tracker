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
    let filter: TrackersFilter
    
    init(
        date: Date,
        search: String = "",
        filter: TrackersFilter = .all
    ) {
        self.date = date
        self.search = search
        self.filter = filter
    }
}
