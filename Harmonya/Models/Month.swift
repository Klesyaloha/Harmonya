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
        
        guard let startDate = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: startDate) else {
            return []
        }
        
        // Obtenir le jour de la semaine du premier jour (1 = dimanche, 2 = lundi, ..., 7 = samedi)
        let weekdayOfFirst = calendar.component(.weekday, from: startDate)
        
        // Ajuster pour que le lundi soit le premier jour de la semaine
        // Si premier jour = dimanche (1), on ajoute 6 jours vides, si lundi (2) on ajoute 0, etc.
        let leadingEmptyDays = (weekdayOfFirst - calendar.firstWeekday + 7) % 7
        
        // Ajouter les jours vides avant le mois
        for _ in 0..<leadingEmptyDays {
            result.append(nil)
        }
        
        // Ajouter les jours du mois
        for day in range {
            if let date = calendar.date(from: DateComponents(year: year, month: month, day: day)) {
                result.append(Day(date: date))
            }
        }
        
        return result
    }
}
