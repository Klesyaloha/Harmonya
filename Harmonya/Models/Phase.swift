//
//  Phases.swift
//  Harmonya
//
//  Created by Klesya on 9/26/25.
//

import Foundation

struct Phase: Identifiable, Codable {
    var id: UUID
    var order: Int
    var symbol: String
    var name: String
    var description: String
}
