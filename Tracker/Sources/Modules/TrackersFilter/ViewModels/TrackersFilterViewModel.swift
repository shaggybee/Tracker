//
//  TrackersFilterViewModel.swift
//  Tracker
//
//  Created by Kislov Vadim on 17.06.2026.
//

final class TrackersFilterViewModel: TrackersFilterViewModelProtocol {
    
    // MARK: - Public properties
    var onClose: (() -> Void)?

    // MARK: - Private properties
    private(set) var selectedFilter: TrackersFilter

    // MARK: - Initializers
    init(selectedFilter: TrackersFilter) {
        self.selectedFilter = selectedFilter
    }

    // MARK: - Public methods
    func select(_ filter: TrackersFilter) {
        selectedFilter = filter

        onClose?()
    }
    
    func isSelected(_ filter: TrackersFilter) -> Bool {
        selectedFilter == filter
    }
}
