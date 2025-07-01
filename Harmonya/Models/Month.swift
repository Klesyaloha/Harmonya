//
//  Month.swift
//  HarmonyaCyrcleCycle
//
//  Created by Klesya on 5/13/25.
//

import Foundation

struct Month {
    var month: Int
    var year: Int
    var days: [Day?]

    init(month: Int, year: Int) {
        self.month = month
        self.year = year
        self.days = Self.generateDays(for: month, year: year)
    }

    static func generateDays(for month: Int, year: Int) -> [Day?] {
        var result: [Day?] = []
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month)
        
        // Trouver le premier jour du mois
        guard let startDate = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: startDate) else {
            return []
        }
        
        // Trouver le jour de la semaine du premier jour du mois (1 = dimanche, 7 = samedi)
        let weekdayOfFirst = calendar.component(.weekday, from: startDate) // Dimanche = 1, Lundi = 2, etc.
        
        // Calculer le nombre de jours vides avant le premier jour du mois
        // Exemple : Si le mois commence un mercredi (3), il faut ajouter 2 jours vides (dimanche et lundi)
        let leadingEmptyDays = (weekdayOfFirst - 1) % 7
        
        // Ajouter les jours vides (null) avant le début du mois
        for _ in 0...leadingEmptyDays {
            result.append(nil) // On ajoute une valeur vide (ou nil selon tes besoins)
        }
        
        // Ajouter les vrais jours du mois
        for day in range {
            if let date = calendar.date(from: DateComponents(year: year, month: month, day: day)) {
                result.append(Day(date: date))
            }
        }
        
        return result
    }
}
