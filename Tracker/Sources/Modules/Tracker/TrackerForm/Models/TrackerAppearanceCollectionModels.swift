//
//  TrackerAppearanceCollectionModels.swift
//  Tracker
//
//  Created by Kislov Vadim on 17.05.2026.
//

enum TrackerAppearanceItem: Hashable {
    case emoji(model: TrackerEmojiCellModel)
    case color(model: TrackerColorCellModel)
}

struct TrackerAppearanceSectionModel {
    let name: String
    let items: [TrackerAppearanceItem]
}

struct TrackerAppearanceCollectionModel {
    let sections: [TrackerAppearanceSectionModel]
}
