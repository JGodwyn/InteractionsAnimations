//
//  Theme.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 12/01/2026.
//

import Foundation
import SwiftUI

enum BrandColors {
    // Grays
    static let Gray0 : Color = Color("Gray0")
    static let Gray100 : Color = Color("Gray100")
    static let Gray200 : Color = Color("Gray200")
    static let Gray300 : Color = Color("Gray300")
    static let Gray400 : Color = Color("Gray400")
    static let Gray500 : Color = Color("Gray500")
    static let Gray600 : Color = Color("Gray600")
    static let Gray700 : Color = Color("Gray700")
    static let Gray800 : Color = Color("Gray800")
    static let Gray900 : Color = Color("Gray900")
    static let Gray1000 : Color = Color("Gray1000")
}

enum BrandImages {
    // for all the brand images
    static let AppLogo : Image = Image("AppLogo")
}

extension Color {
    init(hex: String) {
        let hex = String(hex.dropFirst()).replacingOccurrences(
            of: "#",
            with: ""
        )
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        let a = hex.count == 8 ? Double((rgb >> 24) & 0xFF) / 255.0 : 1.0
        self.init(red: r, green: g, blue: b, opacity: a)
    }

    var hex: String {
        let uiColor = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(
            format: "#%02lX%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255)),
            lroundf(Float(a * 255))
        )
    }
}
