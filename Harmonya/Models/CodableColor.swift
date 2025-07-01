//
//  CodableColor.swift
//  Harmonya
//
//  Created by Klesya on 7/1/25.
//

import Foundation
import SwiftUI

struct CodableColor: Codable, Equatable , ShapeStyle {
    var red: Double
    var green: Double
    var blue: Double
    var opacity: Double
    
    var swiftUIColor: Color {
        Color(red: red, green: green, blue: blue).opacity(opacity)
    }

    init(color: Color) {
        let uiColor = UIColor(color)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.red = Double(r)
        self.green = Double(g)
        self.blue = Double(b)
        self.opacity = Double(a)
    }

    init(red: Double, green: Double, blue: Double, opacity: Double) {
        self.red = red
        self.green = green
        self.blue = blue
        self.opacity = opacity
    }
}
