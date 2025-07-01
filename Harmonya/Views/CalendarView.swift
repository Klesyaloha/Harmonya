//
//  CalendarView.swift
//  HarmonyaCyrcleCycle
//
//  Created by Klesya on 5/13/25.
//

import SwiftUI

struct CalendarView: View {
    @StateObject var calendarManager : CalendarManager
    @State private var showingAddEvent = false
    
    let daysOfWeek = ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"]
    
    let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f
    }()

    var body: some View {
        // MARK: - Navigation
        NavigationView {
            ScrollView {
                VStack(spacing: 50){
                    
                    Image("harmonyaLogo")
                    
                    if let selectedDate = calendarManager.selectedDate {
                        let eventsOfDay = calendarManager.events(for: selectedDate).filter {
                            Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
                        }

                        if let phaseEvent = eventsOfDay.first(where: { $0.title.contains("Phase") }) {
                            withAnimation {
                                switch (phaseEvent.title, phaseEvent.description) {
                                    
                                // 🩸 Menstruation
                                case ("Phase menstruelle", "Jour 1"):
                                    Text("🩸 Jour 1 : Repose-toi, ton corps se régénère.")
                                case ("Phase menstruelle", "Jour 2"):
                                    Text("🩸 Jour 2 : Hydrate-toi et mange du fer 🍲")
                                case ("Phase menstruelle", "Jour 3"):
                                    Text("🩸 Jour 3 : Chaleur, calme et amour 💗")
                                case ("Phase menstruelle", "Jour 4"):
                                    Text("🩸 Jour 4 : La lumière revient doucement ☀️")
                                case ("Phase menstruelle", "Jour 5"):
                                    Text("🩸 Jour 5 : Prépare-toi à renaître 🌱")
                                case ("Phase menstruelle", "Jour 6"):
                                    Text("🩸 Jour 6 : C’est le moment de ralentir encore un peu, juste pour toi ☕️")
                                case ("Phase menstruelle", "Jour 7"):
                                    Text("🩸 Jour 7 : Tu fermes une boucle, le corps est prêt à s’élever de nouveau 🌙")
                                    
                                // 🌱 Phase folliculaire
                                case ("Phase folliculaire", "Jour 1"):
                                    Text("🌱 Jour 1 : retrouve ton énergie doucement.")
                                case ("Phase folliculaire", "Jour 2"):
                                    Text("🌱 Jour 2 : planifie, ton mental est au top 🧠")
                                case ("Phase folliculaire", "Jour 3"):
                                    Text("🌱 Jour 3 : créativité et motivation au rendez-vous 🎨")
                                case ("Phase folliculaire", "Jour 4"):
                                    Text("🌱 Jour 4 : ton glow naturel revient ✨")
                                case ("Phase folliculaire", "Jour 5"):
                                    Text("🌱 Jour 5 : bouge, crée, inspire 💃")
                                case ("Phase folliculaire", "Jour 6"):
                                    Text("🌱 Jour 6 : une belle journée pour socialiser 🤝")
                                case ("Phase folliculaire", "Jour 7"):
                                    Text("🌱 Jour 7 : tu rayonnes, fonce 🌟")
                                    
                                // 🌕 Ovulation
                                case ("Phase ovulatoire", "Jour 1"):
                                    Text("🌕 Jour 1 : période de pleine puissance, exprime-toi 💖")
                                case ("Phase ovulatoire", "Jour 2"):
                                    Text("🌕 Jour 2 : confiance, sensualité, magnétisme 🌺")
                                    
                                // 🔥 Phase lutéale
                                case ("Phase lutéale", "Jour 1"):
                                    Text("🔥 Jour 1 : ralentis un peu, recentre-toi 🧘‍♀️")
                                case ("Phase lutéale", "Jour 2"):
                                    Text("🔥 Jour 2 : équilibre ton humeur avec du magnésium 🍫")
                                case ("Phase lutéale", "Jour 3"):
                                    Text("🔥 Jour 3 : tu es plus intuitive aujourd’hui 🔮")
                                case ("Phase lutéale", "Jour 4"):
                                    Text("🔥 Jour 4 : fais du tri autour et en toi 🧹")
                                case ("Phase lutéale", "Jour 5"):
                                    Text("🔥 Jour 5 : chouchoute-toi, tu le mérites 💆‍♀️")
                                case ("Phase lutéale", "Jour 6"):
                                    Text("🔥 Jour 6 : émotions en vue, sois douce avec toi 💌")
                                case ("Phase lutéale", "Jour 7"):
                                    Text("🔥 Jour 7 : connecte-toi à ton monde intérieur 🌙")
                                case ("Phase lutéale", "Jour 8"):
                                    Text("🔥 Jour 8 : accepte de ralentir – ton corps te parle ❤️")
                                case ("Phase lutéale", "Jour 9"):
                                    Text("🔥 Jour 9 : petite fatigue ? Repose-toi sans culpabilité 🛌")
                                case ("Phase lutéale", "Jour 10"):
                                    Text("🔥 Jour 10 : bientôt les règles, prends soin de toi ☕")

                                default:
                                    Text("💗 Journée spéciale – écoute ton corps et ta sagesse intérieure.")
                                }
                            }
                        }
                    }


                    
                    Button(action: {
                        calendarManager.goToToday()
                    }) {
                        Label("Revenir à aujourd’hui 📍", systemImage: "calendar")
                            .font(.subheadline)
                            .padding(8)
                            .background(Color.sunset.opacity(0.2))
                            .cornerRadius(8)
                            .foregroundColor(.black)
                    }
                    
                    VStack {
                        HStack {
                            Button(action: {
                                calendarManager.goToPreviousMonth()
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.black)
                            }
                            
                            Spacer()
                            
                            Text("\(monthName(calendarManager.currentMonth.month)) \(calendarManager.currentMonth.year.description)")
                                .font(.PlayfairDisplaySC.bold(size: 30))
                            
                            Spacer()
                            
                            Button(action: {
                                calendarManager.goToNextMonth()
                            }) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            ForEach(daysOfWeek, id: \.self) { day in
                                Text(day)
                                    .font(.caption)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.vertical, 4)
                        
                        // MARK: - 􀉉 Days Grid
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7), spacing: 10) {
                            ForEach(Array(calendarManager.currentMonth.days.enumerated()), id: \.offset) { index, day in
                                if let day = day {
                                    Button(action: {
                                        calendarManager.selectedDate = day.date
                                    }) {
                                        VStack {
                                            Text(dateFormatter.string(from: day.date))
                                                .fontWeight(.medium)
                                                .frame(maxWidth: .infinity)
                                                .padding(8)
                                                .background(Calendar.current.isDate(day.date, inSameDayAs: calendarManager.selectedDate ?? Date()) ? Color.blue.opacity(0.2) : Color.clear)
                                                .clipShape(Circle())
                                            if !day.events.isEmpty {
                                                if let event = day.events.first {
                                                    Circle()
                                                        .fill(event.color)
                                                        .frame(width: 6, height: 6)
                                                }
                                            }
                                        }
                                    }
                                    .buttonStyle(.plain)
                                } else {
                                    // 🎯 Case vide pour les nil
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(height: 40) // Hauteur à ajuster selon ta grille
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // MARK: - 􀑎 Button add Event
                        
                        if let selected = calendarManager.selectedDate {
                            EventListView(date: selected, events: calendarManager.events(for: selected))
                        }
                        
                        Button(" + Ajouter un événement") {
                            showingAddEvent = true
                        }
                        .foregroundColor(.lilac)
                        .padding()
                        .sheet(isPresented: $showingAddEvent) {
                            if let selected = calendarManager.selectedDate {
                                AddEventView(date: selected, manager: calendarManager)
                            }
                        }
                    }
                    .padding()
                    .background(
                        Rectangle()
                            .foregroundStyle(.olivine.opacity(0.5))
                            .frame(width: 390.0)
                            .cornerRadius(30)
                    )
                    .navigationBarTitleDisplayMode(.inline)
                }
                .navigationTitle("Welcome ")
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
    CalendarView(calendarManager: CalendarManager())
}
