//
//  Cycle.swift
//  Harmonya
//
//  Created by Klesya on 5/3/25.
//

import Foundation

struct CycleEvent: Identifiable, Hashable {
    let id = UUID()
    var date: Date
    var type: CycleType
    var note: String
}
