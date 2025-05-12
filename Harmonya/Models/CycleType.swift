//
//  CycleType.swift
//  Harmonya
//
//  Created by Klesya on 5/12/25.
//

enum CycleType: String, CaseIterable, Identifiable {
    case menstruel = "Menstruel"
    case lunaire = "Lunaire"
    case saison = "Saisonnier"
    
    var id: String { rawValue }
    var emoji: String {
        switch self {
        case .menstruel: return "🩸"
        case .lunaire: return "🌕"
        case .saison: return "🍂"
        }
    }
}
