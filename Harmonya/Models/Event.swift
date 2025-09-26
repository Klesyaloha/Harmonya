//
//  Event.swift
//  HarmonyaCyrcleCycle
//
//  Created by Klesya on 5/13/25.
//

import Foundation
import SwiftUICore

struct Event: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var date: Date
    var description: String
    var symbol: String
    var color: Color
    var userId: UUID
    
    enum CodingKeys: String, CodingKey {
        case id, title, date, description, symbol, color
        case userId = "user_id"
    }
    
    init(id: UUID = UUID(), userId: UUID, title: String, date: Date, description: String, symbol: String, color: Color) {
        self.id = id
        self.userId = userId
        self.title = title
        self.date = date
        self.description = description
        self.symbol = symbol
        self.color = color
    }
    
    // MARK: - Décodage (JSON -> Event)
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        userId = try container.decode(UUID.self, forKey: .userId)
        title = try container.decode(String.self, forKey: .title)
        date = try container.decode(Date.self, forKey: .date)
        description = try container.decode(String.self, forKey: .description)
        symbol = try container.decode(String.self, forKey: .symbol)
        
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
        try container.encode(date, forKey: .date)
        try container.encode(description, forKey: .description)
        try container.encode(symbol, forKey: .symbol)
        
        // ⚡️ On convertit la Color en RGBA string
        try container.encode(color.toRGBAString(), forKey: .color)
    }
}
