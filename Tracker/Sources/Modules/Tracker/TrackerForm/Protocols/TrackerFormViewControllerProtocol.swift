//
//  TrackerFormViewControllerProtocol.swift
//  Tracker
//
//  Created by Kislov Vadim on 08.05.2026.
//

import Foundation

protocol TrackerFormViewControllerProtocol: AnyObject {
    var presenter: TrackerFormViewPresenterProtocol? { get set }
    func setSubmitButtonEnabled(_ isEnabled: Bool)
    func setTrackerNameFieldError(_ error: String?)
    func setDescription(for trackerOption: TrackerOptionType, with text: String)
}
