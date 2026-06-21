//
//  TrackersFilterViewModelProtocol.swift
//  Tracker
//
//  Created by Kislov Vadim on 17.06.2026.
//

protocol TrackersFilterViewModelProtocol {
    var selectedFilter: TrackersFilter { get }
    var onClose: Completion? { get set }
    func isSelected(_ filter: TrackersFilter) -> Bool
    func select(_ filter: TrackersFilter)
}
