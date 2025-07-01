//
//  Genre.swift
//  Harmonya
//
//  Created by Klesya on 7/1/25.
//

import Foundation

enum Genre: String, Codable, CaseIterable, Identifiable {
    case male
    case female
    case nonbinary

    var id: String { self.rawValue }

    var label: String {
        switch self {
        case .male: return "Masculin"
        case .female: return "Féminin"
        case .nonbinary: return "Non-Binaire"
        }
    }
}
