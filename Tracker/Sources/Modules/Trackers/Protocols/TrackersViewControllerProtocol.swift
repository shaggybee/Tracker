//
//  TrackersViewControllerProtocol.swift
//  Tracker
//
//  Created by Kislov Vadim on 09.05.2026.
//

import Foundation

protocol TrackersViewControllerProtocol: AnyObject {
    var presenter: TrackersViewPresenterProtocol? { get }
    func updateViewModel(_ viewModel: TrackersCollectionViewModel)
    func setEmptyStateVisible(_ isVisible: Bool)
}
