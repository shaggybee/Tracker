//
//  UIColor+Extensions.swift
//  Tracker
//
//  Created by Kislov Vadim on 11.05.2026.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        var hexCode = hexString
        var rgbValue: UInt64 = 0
        
        if hexCode.hasPrefix("#") {
            hexCode.remove(at: hexCode.startIndex)
        }
        
        Scanner(string: hexCode).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}
