//
//  Cycle.swift
//  HarmonyaCyrcleCycle
//
//  Created by Klesya on 5/14/25.
//

import Foundation
import SwiftUI

struct Cycle: Identifiable, Equatable, Codable, Hashable {
    var id: UUID
    let name: String
    let duration: Int
    var texts: [Paragraph]
    let lightColor: Color
    let darkColor: Color

    enum CodingKeys: String, CodingKey {
        case id, name, duration, texts
        case lightColor = "lightColor"  // Utiliser exactement "lightColor" comme dans la réponse JSON
        case darkColor = "darkColor"    // Utiliser exactement "darkColor" comme dans la réponse JSON
    }

    init (id: UUID = UUID(), name: String, duration: Int, texts: [Paragraph], lightColor: Color, darkColor: Color) {
        self.id = id
        self.name = name
        self.duration = duration
        self.texts = texts
        self.lightColor = lightColor
        self.darkColor = darkColor
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        duration = try container.decode(Int.self, forKey: .duration)
        texts = try container.decode([Paragraph].self, forKey: .texts)

        // Convertir les chaînes RGBA en objets Color
        let lightColorString = try container.decode(String.self, forKey: .lightColor)
        lightColor = Color.fromRGBAString(lightColorString)

        let darkColorString = try container.decode(String.self, forKey: .darkColor)
        darkColor = Color.fromRGBAString(darkColorString)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(duration, forKey: .duration)
        try container.encode(texts, forKey: .texts)

        // Convertir les couleurs en chaînes RGBA avant de les encoder
        try container.encode(lightColor.toRGBAString(), forKey: .lightColor)
        try container.encode(darkColor.toRGBAString(), forKey: .darkColor)
    }
}

