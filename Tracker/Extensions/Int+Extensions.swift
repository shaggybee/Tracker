//
//  Int+Extensions.swift
//  Tracker
//
//  Created by Kislov Vadim on 11.05.2026.
//

import Foundation

extension Int {
    func formatRussianPlural(for forms: (one: String, few: String, many: String)) -> String {
        let lastTwoDigits = self % 100
        
        if (11...14).contains(lastTwoDigits) {
            return "\(self) \(forms.many)"
        }
        
        return switch self % 10 {
        case 1: "\(self) \(forms.one)"
        case 2, 3, 4: "\(self) \(forms.few)"
        default: "\(self) \(forms.many)"
        }
    }
}
