//
//  SwiftUIView2.swift
//  Harmonya
//
//  Created by Klesya on 5/4/25.
//

import SwiftUI

struct CalendarView: View {
    @State private var currentDate = Date()
    @State private var selectedDate: Date? = nil

    var body: some View {
        VStack {
            Button("Revenir à aujourd’hui 📍") {
                currentDate = Date()
                selectedDate = nil
            }
            .padding(.top, 8)
            .padding(.bottom)
            .font(.subheadline)
            .foregroundStyle(.blue)
            .buttonStyle(BorderedButtonStyle())
            
            VStack {
                Spacer()
                // Header avec nom du mois
                Text(monthYearString(for: currentDate))
                    .font(.PlayfairDisplaySC.bold(size: 40))
                    .padding()
                    .foregroundStyle(.white)
                
                // Jours de la semaine
                HStack {
                    ForEach(["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"], id: \.self) { day in
                        Text(day).frame(maxWidth: .infinity)
                    }
                }
                
                // Grille de jours
                let days = generateDays(for: currentDate)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                    ForEach(days, id: \.self) { date in
                        if let date = date {
                            Button(action: {
                                selectedDate = date
                            }) {
                                Text("\(Calendar.current.component(.day, from: date))")
                                    .frame(maxWidth: .infinity)
                                    .padding(8)
                                    .background(
                                        Calendar.current.isDateInToday(date) ? Color.sunset :
                                            (selectedDate != nil && Calendar.current.isDate(date, inSameDayAs: selectedDate!)) ? Color.skyBlue.opacity(0.7) : Color.clear
                                    )
                                    .clipShape(Circle())
                            }
                            .buttonStyle(PlainButtonStyle()) // évite le style par défaut de bouton
                        } else {
                            Text("") // cases vides
                        }
                    }
                }
                .padding()
                
                
                // Navigation
                HStack {
                    Image(systemName: "backward.frame.fill")
                        .foregroundStyle(.black)
                    Button("Mois précédent") {
                        changeMonth(by: -1)
                    }
                    .foregroundStyle(.black)
                    
                    Spacer()
                    Button("Mois suivant") {
                        changeMonth(by: 1)
                    }
                    .foregroundStyle(.black)
                    
                    Image(systemName: "forward.frame.fill")
                        .foregroundStyle(.black)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .background(
                Rectangle()
                    .foregroundStyle(.lilac.opacity(0.5))
                    .frame(width: 390.0, height: 470)
                    .cornerRadius(30)
            )
            .padding()
            
            Spacer()
            if let selected = selectedDate {
                VStack(alignment: .leading, spacing: 10) {
                    Text("📅 Le \(formattedDate(selected))")
                        .font(.headline)
                        .padding(.top)
                    
                    // 🔁 Remplace par tes vraies données
                    ForEach(events(for: selected), id: \.self) { event in
                        Text("• \(event)")
                            .padding(.leading)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
            }
            
            Spacer()
        }
        
    }
    
    // 📌 Exemple d'événements fictifs
    private func events(for date: Date) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let sampleEvents: [String: [String]] = [
            "2025-05-12": ["Réunion équipe", "Dentiste à 15h"],
            "2025-05-14": ["Cours de yoga", "Soirée cinéma"]
        ]
        
        let key = formatter.string(from: date)
        return sampleEvents[key] ?? ["Aucun événement"]
    }

    // 🧾 Formatter simple pour la date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: date)
    }
    
    // 🔁 Changer le mois
    private func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentDate) {
            currentDate = newDate
        }
    }

    // 📆 Générer les jours du mois (avec décalage du premier jour)
    private func generateDays(for date: Date) -> [Date?] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2 // Commencer par lundi

        // Début du mois
        guard let range = calendar.range(of: .day, in: .month, for: date),
              let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))
        else { return [] }

        let weekdayOfFirst = calendar.component(.weekday, from: firstOfMonth)
        let leadingEmptyDays = (weekdayOfFirst + 5) % 7 // décalage pour Lundi = 0

        var days: [Date?] = Array(repeating: nil, count: leadingEmptyDays)

        for day in range {
            if let fullDate = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(fullDate)
            }
        }

        return days
    }

    // 🗓️ Format texte du mois
    private func monthYearString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: date).capitalized
    }
}


#Preview {
    CalendarView()
}
