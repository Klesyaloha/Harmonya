//
//  CalendarManager.swift
//  HarmonyaCyrcleCycle
//
//  Created by Klesya on 5/13/25.
//

import Foundation

class CalendarManager: ObservableObject {
    @Published var currentMonth: Month
    @Published var selectedDate: Date? = nil
    @Published var allEvents: [Event] = []
    var user : User = User()

    
    // Initialisation automatique avec la date actuelle
    init() {
        let today = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: today)
        
        if let month = components.month, let year = components.year {
            self.currentMonth = Month(month: month, year: year)  // Initialisation avec le mois et l'année d'aujourd'hui
        } else {
            // Si l'on ne parvient pas à obtenir le mois et l'année (ce qui ne devrait pas arriver normalement), initialise avec janvier 2025 par défaut
            self.currentMonth = Month(month: 1, year: 2025)
        }
    }
    
    func addEvent(_ event: Event) {
        allEvents.append(event)

        if let index = currentMonth.days.firstIndex(where: { day in
            guard let date = day?.date else { return false }
            return Calendar.current.isDate(date, inSameDayAs: event.date)
        }) {
            currentMonth.days[index]?.events.append(event)
        }
    }


    func events(for date: Date) -> [Event] {
        return currentMonth.days.first(where: {
            if let day = $0 {
                return Calendar.current.isDate(day.date, inSameDayAs: date)
            }
            return false
        })??.events ?? []
    }

    func goToPreviousMonth() {
        var newMonth = currentMonth.month - 1
        var newYear = currentMonth.year

        if newMonth == 0 {
            newMonth = 12
            newYear -= 1
        }

        var newMonthObj = Month(month: newMonth, year: newYear)
        for (index, day) in newMonthObj.days.enumerated() {
            guard let date = day?.date else { continue }
            let eventsForDay = allEvents.filter {
                Calendar.current.isDate($0.date, inSameDayAs: date)
            }
            newMonthObj.days[index]?.events = eventsForDay
        }
        currentMonth = newMonthObj
        
        selectedDate = Calendar.current.date(from: DateComponents(year: newYear, month: newMonth, day: 1))
    }

    func goToNextMonth() {
        var newMonth = currentMonth.month + 1
        var newYear = currentMonth.year

        if newMonth == 13 {
            newMonth = 1
            newYear += 1
        }

        var newMonthObj = Month(month: newMonth, year: newYear)
        for (index, day) in newMonthObj.days.enumerated() {
            guard let date = day?.date else { continue }
            let eventsForDay = allEvents.filter {
                Calendar.current.isDate($0.date, inSameDayAs: date)
            }
            newMonthObj.days[index]?.events = eventsForDay
        }
        currentMonth = newMonthObj
        selectedDate = Calendar.current.date(from: DateComponents(year: newYear, month: newMonth, day: 1))
    }
    
    func goToToday() {
        let today = Date()
        selectedDate = today

        // 🎯 Filtre tous les événements de allEvents qui sont dans le mois de "today"
        let calendar = Calendar.current
        let targetComponents = calendar.dateComponents([.year, .month], from: today)

        let monthlyEvents = allEvents.filter { event in
            let eventComponents = calendar.dateComponents([.year, .month], from: event.date)
            return eventComponents.year == targetComponents.year && eventComponents.month == targetComponents.month
        }

        currentMonth = CalendarManager.generateMonth(for: today, with: monthlyEvents)
    }

    static func generateMonth(for date: Date, with events: [Event]) -> Month {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        
        var month = Month(month: components.month!, year: components.year!)
        
        // Ajoute les événements au bon jour du mois
        for event in events {
            for i in month.days.indices {
                if let dayDate = month.days[i]?.date,
                   calendar.isDate(dayDate, inSameDayAs: event.date) {
                    month.days[i]?.events.append(event)
                }
            }
        }
        
        return month
    }
    
    func removeEvents() {
        allEvents.removeAll()
        goToToday()
        
    }
}
