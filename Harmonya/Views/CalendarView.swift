//
//  CalendarView.swift
//  HarmonyaCyrcleCycle
//
//  Created by Klesya on 5/13/25.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var calendarManager: CalendarManager
    @State private var showingAddEvent = false
    @EnvironmentObject var userManager: UserViewModel

    let daysOfWeek = ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"]

    let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f
    }()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 50) {
//                    Image("harmonyaLogo")

                    Text("Bonjour \(userManager.currentUser.nameUser)")
                        .multilineTextAlignment(.leading)
                    
                    phaseEventView()

                    todayButton

                    monthGrid
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Image("harmonyaLogoSimple")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    }
                }
                .navigationTitle("Welcome \(userManager.currentUser.nameUser)")
            }
        }
        .task(id: userManager.currentUser.id) {
            await calendarManager.loadEvents(for: userManager.currentUser.id)
        }
    }

    @ViewBuilder
    private func phaseEventView() -> some View {
        if let selectedDate = calendarManager.selectedDate {
            let eventsOfDay = calendarManager.events(for: selectedDate).filter {
                Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
            }
            
            if let phaseEvent = eventsOfDay.first(where: { $0.title.contains("Phase") }) {
                withAnimation {
                    phaseText(for: phaseEvent)
                        .padding(.all, 7)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }
        }
    }

    @ViewBuilder
    private func phaseText(for event: Event) -> some View {
        switch (event.title, event.description) {
                
        // 🌹 Phase menstruelle (3 à 7 jours possibles)
        case ("Phase menstruelle", "Jour 1"):
            Text("🩸 Jour 1 : Repose-toi, ton corps se régénère.")
        case ("Phase menstruelle", "Jour 2"):
            Text("🩸 Jour 2 : Hydrate-toi et recharge en fer 🍲.")
        case ("Phase menstruelle", "Jour 3"):
            Text("🩸 Jour 3 : Ton énergie revient doucement 💕.")
        case ("Phase menstruelle", "Jour 4"):
            Text("🩸 Jour 4 : Tu ressens plus de légèreté ✨.")
        case ("Phase menstruelle", "Jour 5"):
            Text("🩸 Jour 5 : La lumière intérieure renaît 🌸.")
        case ("Phase menstruelle", "Jour 6"):
            Text("🩸 Jour 6 : Tu sors de la régénération, retrouve ton élan 🌞.")
        case ("Phase menstruelle", "Jour 7"):
            Text("🩸 Jour 7 : Fin des règles, tu prépares ton corps à fleurir 🌱.")
                
        // 🌱 Phase folliculaire (jusqu’à l’ovulation, environ 7-10 jours)
        case ("Phase folliculaire", "Jour 1"):
            Text("🌱 Jour 1 : Ton énergie redémarre en douceur 🌿.")
        case ("Phase folliculaire", "Jour 2"):
            Text("🌱 Jour 2 : Tu es créative et légère 🎨.")
        case ("Phase folliculaire", "Jour 3"):
            Text("🌱 Jour 3 : Profite de ton dynamisme naissant 🌞.")
        case ("Phase folliculaire", "Jour 4"):
            Text("🌱 Jour 4 : Tu rayonnes, parfait pour initier 🚀.")
        case ("Phase folliculaire", "Jour 5"):
            Text("🌱 Jour 5 : Ton esprit est clair et vif 🧠.")
        case ("Phase folliculaire", "Jour 6"):
            Text("🌱 Jour 6 : L’énergie sociale t’accompagne 💬.")
        case ("Phase folliculaire", "Jour 7"):
            Text("🌱 Jour 7 : Ton magnétisme s’amplifie ✨.")
        case ("Phase folliculaire", "Jour 8"):
            Text("🌱 Jour 8 : Journée idéale pour apprendre 📚.")
        case ("Phase folliculaire", "Jour 9"):
            Text("🌱 Jour 9 : Tu es prête à fleurir 🌸.")
        case ("Phase folliculaire", "Jour 10"):
            Text("🌱 Jour 10 : Confiance et ouverture maximale 🌈.")
                
        // 🌕 Phase ovulatoire (3 jours environ)
        case ("Phase ovulatoire", "Jour 1"):
            Text("🌕 Jour 1 : Tu es dans ta pleine puissance 💖.")
        case ("Phase ovulatoire", "Jour 2"):
            Text("🌕 Jour 2 : Charisme et communication au top 💫.")
        case ("Phase ovulatoire", "Jour 3"):
            Text("🌕 Jour 3 : Partage ton amour et ton énergie 🌟.")
                
        // 🔥 Phase lutéale (10-14 jours selon cycle)
        case ("Phase lutéale", "Jour 1"):
            Text("🔥 Jour 1 : Ralentis, recentre-toi 🧘‍♀️.")
        case ("Phase lutéale", "Jour 2"):
            Text("🔥 Jour 2 : Mets ton énergie dans les détails 📝.")
        case ("Phase lutéale", "Jour 3"):
            Text("🔥 Jour 3 : Ton intuition est très fine 🌙.")
        case ("Phase lutéale", "Jour 4"):
            Text("🔥 Jour 4 : Besoin de douceur, offre-toi du réconfort ☕.")
        case ("Phase lutéale", "Jour 5"):
            Text("🔥 Jour 5 : Prends soin de ton corps avec tendresse 🤍.")
        case ("Phase lutéale", "Jour 6"):
            Text("🔥 Jour 6 : La créativité intérieure se déploie 🎶.")
        case ("Phase lutéale", "Jour 7"):
            Text("🔥 Jour 7 : Protège ton énergie, sois à l’écoute 🛡️.")
        case ("Phase lutéale", "Jour 8"):
            Text("🔥 Jour 8 : Idéal pour organiser et finaliser 📂.")
        case ("Phase lutéale", "Jour 9"):
            Text("🔥 Jour 9 : Accueille le lâcher-prise 🌊.")
        case ("Phase lutéale", "Jour 10"):
            Text("🔥 Jour 10 : Chouchoute-toi, ton corps le réclame 💆‍♀️.")
        case ("Phase lutéale", "Jour 11"):
            Text("🔥 Jour 11 : Respire, le nouveau cycle approche 🌬️.")
        case ("Phase lutéale", "Jour 12"):
            Text("🔥 Jour 12 : Prépare-toi avec douceur 🌹.")
        case ("Phase lutéale", "Jour 13"):
            Text("🔥 Jour 13 : Ton énergie ralentit, sois indulgente 💜.")
        case ("Phase lutéale", "Jour 14"):
            Text("🔥 Jour 14 : Dernier jour, demain la régénération revient 🩸.")
                
        // 🌸 Par défaut
        default:
            Text("💗 Journée spéciale – écoute ton corps et ta sagesse intérieure.")
        }
    }


    private var todayButton: some View {
        Button(action: { calendarManager.goToToday() }) {
            Label("Aujourd’hui 📍", systemImage: "calendar")
                .font(.subheadline)
                .padding(8)
                .background(Color.sunset.opacity(0.2))
                .cornerRadius(8)
                .foregroundColor(.black)
        }
    }

    private var monthGrid: some View {
        VStack {
            HStack {
                monthNavigationButton(systemName: "chevron.left", action: calendarManager.goToPreviousMonth)
                Spacer()
                Text("\(monthName(calendarManager.currentMonth.month)) \(calendarManager.currentMonth.year.description)")
                    .font(.PlayfairDisplaySC.bold(size: 30))
                Spacer()
                monthNavigationButton(systemName: "chevron.right", action: calendarManager.goToNextMonth)
            }
            .padding(.horizontal)

            dayOfWeekHeader
            daysGrid
//                .background(.red)
            
            if let selected = calendarManager.selectedDate {
                EventListView(date: selected, events: calendarManager.events(for: selected))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)
//                    .background(.blue)
            }
            addEventButton
        }
        .padding()
        .background(
            Rectangle()
                .foregroundStyle(.olivine.opacity(0.5))
                .cornerRadius(30)
        )
    }

    private func monthNavigationButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .foregroundColor(.black)
        }
    }

    private var dayOfWeekHeader: some View {
        HStack {
            ForEach(daysOfWeek, id: \.self) { day in
                Text(day)
                    .font(.caption)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 4)
    }

    private var daysGrid: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7), spacing: 10) {
            ForEach(Array(calendarManager.currentMonth.days.enumerated()), id: \.offset) { index, day in
                if let day = day {
                    Button(action: { calendarManager.selectedDate = day.date }) {
                        VStack {
                            Text(dateFormatter.string(from: day.date))
                                .fontWeight(.medium)
                                .frame(width: 30, height: 30)
                                .padding(8)
                                .background(Calendar.current.isDate(day.date, inSameDayAs: calendarManager.selectedDate ?? Date()) ? Color.blue.opacity(0.2) : Color.clear)
                                .clipShape(Circle())
                            if !day.events.isEmpty {
                                HStack {
                                    if day.events.contains(where: { $0.title.contains("Cycle masculin") }) {
                                        Text("♂")
                                            .font(.system(size: 13))
                                    }
                                    ForEach(day.events) { event in
                                       if !event.title.contains("Cycle masculin") {
                                            Text(event.symbol)
                                                .font(.system(size: 7))
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 50)
                    }
                    .buttonStyle(.plain)
                } else {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 40)
                }
            }
        }
        .padding(.horizontal)
    }

    private var addEventButton: some View {
        Button(" + Ajouter un événement") {
            showingAddEvent = true
        }
        .foregroundColor(.lilac)
        .padding()
        .sheet(isPresented: $showingAddEvent) {
            if let selected = calendarManager.selectedDate {
                AddEventView(date: selected)
            }
        }
    }

    func monthName(_ month: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.monthSymbols[month - 1].capitalized
    }
}

#Preview {
    let calendarManager = CalendarManager()
    let userViewModel = UserViewModel()

    CalendarView()
        .environmentObject(calendarManager)
        .environmentObject(userViewModel)
}
