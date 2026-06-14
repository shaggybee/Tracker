//
//  TrackerFormViewPresenterProtocol.swift
//  Tracker
//
//  Created by Kislov Vadim on 08.05.2026.
//

import Foundation

protocol TrackerFormViewPresenterProtocol {
    var view: TrackerFormViewControllerProtocol? { get set }
    var isEditMode: Bool { get }
    var selectedDays: Weekdays { get }
    var categoryName: String? { get }
    var trackerOptions: [TrackerOptionType] { get }
    var trackerFormTitle: String { get }
    var submitButtonTitle: String { get }
    func viewDidLoad()
    func didChangeSelectedDays(_ selectedDays: Weekdays)
    func didChangeTrackerName(_ trackerName: String)
    func didChangeTrackerCategory(_ categoryName: String?)
    func didChangeSelectedEmoji(_ emoji: String)
    func didChangeSelectedColor(_ colorHex: String)
    func getTrackerModel() -> Tracker?
    func createTracker()
    func updateTracker()
}
