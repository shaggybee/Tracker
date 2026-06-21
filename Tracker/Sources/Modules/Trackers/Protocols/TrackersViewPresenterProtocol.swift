//
//  TrackersViewPresenterProtocol.swift
//  Tracker
//
//  Created by Kislov Vadim on 09.05.2026.
//

import Foundation

protocol TrackersViewPresenterProtocol {
    var view: TrackersViewControllerProtocol? { get }
    var selectedDate: Date { get }
    var currentFilter: TrackersFilter { get set }
    func viewDidLoad()
    func viewDidAppear()
    func viewDidDisappear()
    func didTap(_ item: AnalyticsItem)
    func setDate(_ selectedDate: Date)
    func setTrackerCompleted(_ isCompleted: Bool, for trackerId: UUID)
    func searchTrackers(with query: String)
    func deleteTracker(with id: UUID)
    func setTrackerPinned(_ isPinned: Bool, for id: UUID)
    func getTracker(with id: UUID) -> Tracker?
    func setFilter(_ filter: TrackersFilter)
}
