//
//  Event.swift
//  HarmonyaCyrcleCycle
//
//  Created by Klesya on 5/13/25.
//

import Foundation
import SwiftUICore

struct Event: Identifiable {
    var id = UUID()
    var title: String
    var date: Date
    var description: String
    var symbol: String
    var color: Color
    
}
