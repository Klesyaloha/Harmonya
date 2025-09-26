//
//  Journal.swift
//  Harmonya
//
//  Created by Klesya on 9/23/25.
//

import Foundation

struct Journal: Identifiable, Codable {
    var id: UUID = UUID()
    var userId: UUID
    var date: Date
    var content: String
    var tags: [String] = []
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR") // ou "en_US"
        formatter.dateFormat = "EEEE dd MMMM yyyy"
        return formatter.string(from: date).capitalized
    }
}
