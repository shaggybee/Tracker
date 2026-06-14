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
    func viewDidLoad()
    func setDate(_ selectedDate: Date)
    func setTrackerCompleted(_ isCompleted: Bool, for trackerId: UUID)
    func deleteTracker(with id: UUID)
    func setTrackerPinned(_ isPinned: Bool, for id: UUID)
    func getTracker(with id: UUID) -> Tracker?
}
