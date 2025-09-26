//
//  Routine.swift
//  Harmonya
//
//  Created by Klesya on 9/23/25.
//

import Foundation
import SwiftUICore

enum RoutineFrequency: String, Codable, CaseIterable {
    case daily, weekly, monthly
}

enum RoutineSymbol: String, CaseIterable, Codable {
    case sun = "sun.max.fill"
    case moon = "moon.stars.fill"
    case book = "book.fill"
    case bolt = "bolt.fill"
    case leaf = "leaf.fill"
    case flame = "flame.fill"
    case heart = "heart.fill"
}

struct Routine: Identifiable, Codable {
    var id: UUID = UUID()
    var userId: UUID
    var title: String
    var symbol: RoutineSymbol
    var content: [String]
    var color: Color
    var frequency: RoutineFrequency
    var weekday: Int?
    var weekOfMonth: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, userId, title, symbol, content, color, frequency, weekday, weekOfMonth
    }
    
    init(userId: UUID, title: String, symbol: RoutineSymbol, content: [String], color: Color, frequency: RoutineFrequency, weekday: Int? = nil, weekOfMonth: Int? = nil) {
        self.userId = userId
        self.title = title
        self.symbol = symbol
        self.content = content
        self.color = color
        self.frequency = frequency
        self.weekday = weekday
        self.weekOfMonth = weekOfMonth
    }
    
    // MARK: - Décodage (JSON -> Event)
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        userId = try container.decode(UUID.self, forKey: .userId)
        title = try container.decode(String.self, forKey: .title)
        symbol = try container.decode(RoutineSymbol.self, forKey: .symbol)
        content = try container.decode([String].self, forKey: .content)
        frequency = try container.decode(RoutineFrequency.self, forKey: .frequency)
        weekday = try container.decodeIfPresent(Int.self, forKey: .weekday)
        weekOfMonth = try container.decodeIfPresent(Int.self, forKey: .weekOfMonth)
        
        // ⚡️ On récupère le RGBA (string) et on le convertit en Color
        let colorString = try container.decode(String.self, forKey: .color)
        color = Color.fromRGBAString(colorString)
    }
    
    // MARK: - Encodage (Event -> JSON)
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(title, forKey: .title)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(content, forKey: .content)
        try container.encode(frequency, forKey: .frequency)
        try container.encodeIfPresent(weekday, forKey: .weekday)
        try container.encodeIfPresent(weekOfMonth, forKey: .weekOfMonth)
        
        // ⚡️ On convertit la Color en RGBA string
        try container.encode(color.toRGBAString(), forKey: .color)
    }
}
