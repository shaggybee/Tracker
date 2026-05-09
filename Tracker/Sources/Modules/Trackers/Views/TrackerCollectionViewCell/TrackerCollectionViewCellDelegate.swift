//
//  TrackerCollectionViewCellDelegate.swift
//  Tracker
//
//  Created by Kislov Vadim on 09.05.2026.
//

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func trackerCollectionViewCell(_ cell: TrackerCollectionViewCell, didChange isTracked: Bool)
}
