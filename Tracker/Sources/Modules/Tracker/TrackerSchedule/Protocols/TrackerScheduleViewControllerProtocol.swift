//
//  TrackerScheduleViewControllerProtocol.swift
//  Tracker
//
//  Created by Kislov Vadim on 08.05.2026.
//

import Foundation

protocol TrackerScheduleViewControllerProtocol: AnyObject {
    var presenter: TrackerScheduleViewPresenterProtocol? { get set }
}
