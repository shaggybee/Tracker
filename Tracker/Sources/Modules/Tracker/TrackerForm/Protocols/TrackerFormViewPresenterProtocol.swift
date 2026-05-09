//
//  TrackerFormViewPresenterProtocol.swift
//  Tracker
//
//  Created by Kislov Vadim on 08.05.2026.
//

import Foundation

protocol TrackerFormViewPresenterProtocol {
    var view: TrackerFormViewControllerProtocol? { get set }
    var selectedDays: Weekdays { get }
    var trackerName: String { get }
    var trackerOptions: [TrackerOptionType] { get }
    var trackerFormTitle: String { get }
    func viewDidLoad()
    func didChangeSelectedDays(_ selectedDays: Weekdays)
    func didChangeTrackerName(_ trackerName: String)
    func getTrackerModel() -> Tracker
}
