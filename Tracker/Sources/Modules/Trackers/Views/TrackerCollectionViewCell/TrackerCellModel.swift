//
//  TrackerCellModel.swift
//  Tracker
//
//  Created by Kislov Vadim on 09.05.2026.
//

import UIKit

struct TrackerCellViewModel {
    enum ActionButtonState {
        case hidden
        case track
        case untrack
    }
    
    let name: String
    let color: UIColor
    let completedDaysCount: Int
    let actionButtonState: ActionButtonState
}
