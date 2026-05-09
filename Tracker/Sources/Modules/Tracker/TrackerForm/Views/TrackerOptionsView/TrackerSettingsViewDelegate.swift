//
//  TrackerOptionsViewDelegate.swift
//  Tracker
//
//  Created by Kislov Vadim on 06.05.2026.
//

protocol TrackerOptionsViewDelegate: AnyObject {
    func trackerOptionsView(_ view: TrackerOptionsView, didSelect option: TrackerOption)
}
