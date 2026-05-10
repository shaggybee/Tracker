//
//  TrackersViewPresenterProtocol.swift
//  Tracker
//
//  Created by Kislov Vadim on 09.05.2026.
//

import Foundation

protocol TrackersViewPresenterProtocol {
    var view: TrackersViewControllerProtocol? { get }
    var categories: [TrackerCategory] { get }
    var completedTrackers: [TrackerRecord] { get }
    var selectedDate: Date { get }
    func viewDidLoad()
    func addTracker(_ tracker: Tracker)
    func setDate(_ selectedDate: Date)
    func setTrackerCompleted(_ isCompleted: Bool, for trackerId: UUID)
}
