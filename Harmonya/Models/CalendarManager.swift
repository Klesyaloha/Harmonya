//
//  CalendarManager.swift
//  HarmonyaCyrcleCycle
//
//  Created by Klesya on 5/13/25.
//

import Foundation

@MainActor
class CalendarManager: ObservableObject {
    @Published var currentMonth: Month
    @Published var selectedDate: Date? = nil
    @Published var allEvents: [Event] = []

    private let baseURL = "http://127.0.0.1:8080/events"

    // Initialisation automatique avec la date actuelle
    init() {
        let today = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: today)
        
        if let month = components.month, let year = components.year {
            self.currentMonth = Month(month: month, year: year)
        } else {
            self.currentMonth = Month(month: 1, year: 2025)
        }
    }

    // MARK: - Ajouter un event localement (existant)
    func addEvent(_ event: Event) {
        allEvents.append(event)

        if let index = currentMonth.days.firstIndex(where: { day in
            guard let date = day?.date else { return false }
            return Calendar.current.isDate(date, inSameDayAs: event.date)
        }) {
            currentMonth.days[index]?.events.append(event)
        }
    }

    // MARK: - Charger les events d’un utilisateur depuis le serveur (nouveau)
    func loadEvents(for userId: UUID) async {
        guard let url = URL(string: "\(baseURL)/user/\(userId.uuidString)") else { return }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("❌ Erreur serveur lors du fetch des events")
                return
            }

            let decoder = JSONDecoder()
            // ✅ Ici on force la stratégie ISO8601 pour correspondre à ton serveur
            decoder.dateDecodingStrategy = .iso8601

            let events = try decoder.decode([Event].self, from: data)

            // On est sur le MainActor
            self.allEvents = events

            if let selectedDate = selectedDate {
                self.currentMonth = CalendarManager.generateMonth(for: selectedDate, with: events)
            } else {
                self.currentMonth = CalendarManager.generateMonth(for: Date(), with: events)
            }

            print("✅ Loaded \(events.count) events for user \(userId)")

        } catch {
            print("❌ Erreur fetch events: \(error)")
        }
    }

    // MARK: - Ajouter un event sur le serveur (optionnel)
    func addEventOnServer(_ event: Event) async {
        guard let url = URL(string: baseURL) else { return }

        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            request.httpBody = try encoder.encode(event)

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("❌ Erreur serveur lors de l'ajout de l'event")
                return
            }

            let savedEvent = try JSONDecoder().decode(Event.self, from: data)
            self.addEvent(savedEvent)
            print("✅ Event ajouté: \(savedEvent.title)")

        } catch {
            print("❌ Erreur ajout event: \(error)")
        }
    }

    // MARK: - Accéder aux events pour une date (existant)
    func events(for date: Date) -> [Event] {
        return currentMonth.days.first(where: {
            if let day = $0 {
                return Calendar.current.isDate(day.date, inSameDayAs: date)
            }
            return false
        })??.events ?? []
    }

    // MARK: - Navigation dans les mois (existants)
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

        let calendar = Calendar.current
        let targetComponents = calendar.dateComponents([.year, .month], from: today)

        let monthlyEvents = allEvents.filter { event in
            let eventComponents = calendar.dateComponents([.year, .month], from: event.date)
            return eventComponents.year == targetComponents.year && eventComponents.month == targetComponents.month
        }

        currentMonth = CalendarManager.generateMonth(for: today, with: monthlyEvents)
    }

    // MARK: - Génération du mois avec events (existant)
    static func generateMonth(for date: Date, with events: [Event]) -> Month {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        
        var month = Month(month: components.month!, year: components.year!)
        
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
    
    // MARK: - Réinitialiser les events pour un nouvel utilisateur ou à la déconnexion
    @MainActor
    func resetEvents() {
        // On vide tous les events
        allEvents.removeAll()

        // On réinitialise le mois courant à celui d'aujourd'hui
        let today = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: today)
        if let month = components.month, let year = components.year {
            currentMonth = Month(month: month, year: year)
        } else {
            currentMonth = Month(month: 1, year: 2025)
        }

        // On réinitialise la date sélectionnée
        selectedDate = today
    }
    
    @MainActor
    func loadUserEvents(userId: UUID) async {
        resetEvents() // vide les events de l'ancien utilisateur
        await loadEvents(for: userId) // charge les events du nouvel utilisateur
    }
    
    @MainActor
    func deleteEventsFromServer(for userId: UUID) async {
        guard let url = URL(string: "\(baseURL)/user/\(userId.uuidString)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("✅ Events supprimés sur le serveur pour l’utilisateur \(userId)")
            } else {
                print("❌ Erreur serveur lors de la suppression des events")
            }
        } catch {
            print("❌ Erreur lors de la suppression des events: \(error)")
        }
    }
}



//class CalendarManager: ObservableObject {
//    @Published var currentMonth: Month
//    @Published var selectedDate: Date? = nil
//    @Published var allEvents: [Event] = []
//    
//    // Initialisation automatique avec la date actuelle
//    init() {
//        let today = Date()
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.year, .month], from: today)
//        
//        if let month = components.month, let year = components.year {
//            self.currentMonth = Month(month: month, year: year)  // Initialisation avec le mois et l'année d'aujourd'hui
//        } else {
//            // initialise avec janvier 2025 par défaut
//            self.currentMonth = Month(month: 1, year: 2025)
//        }
//    }
//    
//    func addEvent(_ event: Event) {
//        allEvents.append(event)
//
//        if let index = currentMonth.days.firstIndex(where: { day in
//            guard let date = day?.date else { return false }
//            return Calendar.current.isDate(date, inSameDayAs: event.date)
//        }) {
//            currentMonth.days[index]?.events.append(event)
//        }
//    }
//
//
//    func events(for date: Date) -> [Event] {
//        return currentMonth.days.first(where: {
//            if let day = $0 {
//                return Calendar.current.isDate(day.date, inSameDayAs: date)
//            }
//            return false
//        })??.events ?? []
//    }
//
//    func goToPreviousMonth() {
//        var newMonth = currentMonth.month - 1
//        var newYear = currentMonth.year
//
//        if newMonth == 0 {
//            newMonth = 12
//            newYear -= 1
//        }
//
//        var newMonthObj = Month(month: newMonth, year: newYear)
//        for (index, day) in newMonthObj.days.enumerated() {
//            guard let date = day?.date else { continue }
//            let eventsForDay = allEvents.filter {
//                Calendar.current.isDate($0.date, inSameDayAs: date)
//            }
//            newMonthObj.days[index]?.events = eventsForDay
//        }
//        currentMonth = newMonthObj
//        
//        selectedDate = Calendar.current.date(from: DateComponents(year: newYear, month: newMonth, day: 1))
//    }
//
//    func goToNextMonth() {
//        var newMonth = currentMonth.month + 1
//        var newYear = currentMonth.year
//
//        if newMonth == 13 {
//            newMonth = 1
//            newYear += 1
//        }
//
//        var newMonthObj = Month(month: newMonth, year: newYear)
//        for (index, day) in newMonthObj.days.enumerated() {
//            guard let date = day?.date else { continue }
//            let eventsForDay = allEvents.filter {
//                Calendar.current.isDate($0.date, inSameDayAs: date)
//            }
//            newMonthObj.days[index]?.events = eventsForDay
//        }
//        currentMonth = newMonthObj
//        selectedDate = Calendar.current.date(from: DateComponents(year: newYear, month: newMonth, day: 1))
//    }
//    
//    func goToToday() {
//        let today = Date()
//        selectedDate = today
//
//        // 🎯 Filtre tous les événements de allEvents qui sont dans le mois de "today"
//        let calendar = Calendar.current
//        let targetComponents = calendar.dateComponents([.year, .month], from: today)
//
//        let monthlyEvents = allEvents.filter { event in
//            let eventComponents = calendar.dateComponents([.year, .month], from: event.date)
//            return eventComponents.year == targetComponents.year && eventComponents.month == targetComponents.month
//        }
//
//        currentMonth = CalendarManager.generateMonth(for: today, with: monthlyEvents)
//    }
//
//    static func generateMonth(for date: Date, with events: [Event]) -> Month {
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.year, .month], from: date)
//        
//        var month = Month(month: components.month!, year: components.year!)
//        
//        // Ajoute les événements au bon jour du mois
//        for event in events {
//            for i in month.days.indices {
//                if let dayDate = month.days[i]?.date,
//                   calendar.isDate(dayDate, inSameDayAs: event.date) {
//                    month.days[i]?.events.append(event)
//                }
//            }
//        }
//        
//        return month
//    }
//    
//    func removeEvents() {
//        allEvents.removeAll()
//        goToToday()
//        
//    }
//}
