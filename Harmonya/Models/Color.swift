//
//  CodableColor.swift
//  Harmonya
//
//  Created by Klesya on 7/1/25.
//

import Foundation
import SwiftUI

//struct CodableColor: Codable, Equatable , ShapeStyle {
//    var red: Double
//    var green: Double
//    var blue: Double
//    var opacity: Double
//    
//    var swiftUIColor: Color {
//        Color(red: red, green: green, blue: blue).opacity(opacity)
//    }
//
//    init(color: Color) {
//        let uiColor = UIColor(color)
//        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
//        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
//        self.red = Double(r)
//        self.green = Double(g)
//        self.blue = Double(b)
//        self.opacity = Double(a)
//    }
//
//    init(red: Double, green: Double, blue: Double, opacity: Double) {
//        self.red = red
//        self.green = green
//        self.blue = blue
//        self.opacity = opacity
//    }
//}

import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension Color: Codable {
    public func encode(to encoder: Encoder) throws {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        #elseif canImport(AppKit)
        let nsColor = NSColor(self)
        #endif
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        #if canImport(UIKit)
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            throw ColorError.conversionFailed
        }
        #elseif canImport(AppKit)
        guard let rgbColor = nsColor.usingColorSpace(.deviceRGB) else {
            throw ColorError.conversionFailed
        }
        rgbColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        #endif
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(r, forKey: .red)
        try container.encode(g, forKey: .green)
        try container.encode(b, forKey: .blue)
        try container.encode(a, forKey: .alpha)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let r = try container.decode(CGFloat.self, forKey: .red)
        let g = try container.decode(CGFloat.self, forKey: .green)
        let b = try container.decode(CGFloat.self, forKey: .blue)
        let a = try container.decode(CGFloat.self, forKey: .alpha)
        
        self.init(red: Double(r), green: Double(g), blue: Double(b), opacity: Double(a))
    }
    
    private enum CodingKeys: String, CodingKey {
        case red, green, blue, alpha
    }
    
    func toRGBAString() -> String {
            #if canImport(UIKit)
            let uiColor = UIColor(self)
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
            return String(format: "rgba(%.3f, %.3f, %.3f, %.3f)", r, g, b, a)
            #else
            return "rgba(0,0,0,1)" // fallback
            #endif
    }
    
    static func fromRGBAString(_ rgba: String) -> Color {
            let comps = rgba
                .replacingOccurrences(of: "rgba(", with: "")
                .replacingOccurrences(of: ")", with: "")
                .split(separator: ",")
                .compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }

            guard comps.count == 4 else { return .gray }
            return Color(red: comps[0], green: comps[1], blue: comps[2], opacity: comps[3])
        }
}

enum ColorError: Error {
    case conversionFailed
}
