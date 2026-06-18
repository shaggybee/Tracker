//
//  TrackersViewControllerProtocol.swift
//  Tracker
//
//  Created by Kislov Vadim on 09.05.2026.
//

import Foundation

protocol TrackersViewControllerProtocol: AnyObject {
    var presenter: TrackersViewPresenterProtocol? { get }
    func apply(_ model: TrackersCollectionModel)
    func setEmptyState(with model: EmptyStateModel?)
    func setDate(_ date: Date)
    func setFilterAvailability(_ isAvailable: Bool)
}
