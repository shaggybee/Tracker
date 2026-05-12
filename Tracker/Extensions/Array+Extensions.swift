//
//  Array+Extensions.swift
//  Tracker
//
//  Created by Kislov Vadim on 06.05.2026.
//

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
