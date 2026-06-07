//
//  TrackerCategoryFormViewModelProtocol.swift
//  Tracker
//
//  Created by Kislov Vadim on 05.06.2026.
//

protocol TrackerCategoryFormViewModelProtocol {
    var categoryName: String { get }
    var title: String { get }
    var isSaveEnabled: Bool { get }
    var onSaveEnabledChanged: Binding<Bool>? { get set }
    var onCategoryNameErrorChanged: Binding<String?>? { get set }
    var onSaveFailed: Binding<String?>? { get set }
    var onSaveCompleted: Completion? { get set }
    
    func save()
    func didChange(text: String)
}
