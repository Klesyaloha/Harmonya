//
//  Cycle.swift
//  HarmonyaCyrcleCycle
//
//  Created by Klesya on 5/14/25.
//

import Foundation
import SwiftUI

struct Cycle : Identifiable, Equatable {
    var id : UUID = UUID()
    let name: String
    let duration: Int
    var texts : [Paragraph]
    let lightColor : Color
    let darkColor : Color
    
//    // Pour avoir une propriété computed pour récupérer la Color SwiftUI
//    var lightSwiftUIColor: Color { lightColor.swiftUIColor }
//    var darkSwiftUIColor: Color { darkColor.swiftUIColor }
}

