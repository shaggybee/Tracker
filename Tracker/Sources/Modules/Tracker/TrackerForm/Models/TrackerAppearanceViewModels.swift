//
//  TrackerAppearanceViewModels.swift
//  Tracker
//
//  Created by Kislov Vadim on 17.05.2026.
//

enum TrackerAppearanceItem: Hashable {
    case emoji(model: TrackerEmojiCellViewModel)
    case color(model: TrackerColorCellViewModel)
}

struct TrackerAppearanceSectionModel {
    let name: String
    let items: [TrackerAppearanceItem]
}

struct TrackerAppearanceViewModel {
    let sections: [TrackerAppearanceSectionModel]
}
