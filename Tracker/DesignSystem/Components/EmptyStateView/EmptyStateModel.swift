//
//  EmptyStateModel.swift
//  Tracker
//
//  Created by Kislov Vadim on 16.06.2026.
//

import DeveloperToolsSupport

struct EmptyStateModel {
    let text: String
    let image: ImageResource
    
    init(text: String = "", image: ImageResource = .emptyState) {
        self.text = text
        self.image = image
    }
}
