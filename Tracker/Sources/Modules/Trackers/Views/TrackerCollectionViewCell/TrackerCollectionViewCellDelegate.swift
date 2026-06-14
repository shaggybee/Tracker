//
//  TrackerCollectionViewCellDelegate.swift
//  Tracker
//
//  Created by Kislov Vadim on 09.05.2026.
//

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func trackerCollectionViewCell(_ cell: TrackerCollectionViewCell, didToggleCompleted isCompleted: Bool)
    func trackerCollectionViewCell(_ cell: TrackerCollectionViewCell, didTogglePin isPinned: Bool)
    func trackerCollectionViewCellDidTapEdit(_ cell: TrackerCollectionViewCell)
    func trackerCollectionViewCellDidTapDelete(_ cell: TrackerCollectionViewCell)
}
