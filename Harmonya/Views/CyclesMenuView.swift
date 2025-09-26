//
//  CyclesMenuView.swift
//  CalendarApp
//
//  Created by Klesya on 5/14/25.
//

import SwiftUI

struct CyclesMenuView: View {
    @StateObject var cyclesViewModel = CyclesViewModel2()
    @EnvironmentObject var calendarManager: CalendarManager
    @EnvironmentObject var userViewModel: UserViewModel
    @State var showWelcomeView: Bool = false
    @State private var currentCycleIndex = 0

    var body: some View {
        ScrollView {
            ZStack {
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: .white, location: 0.05),
                        Gradient.Stop(color: Color(red: 0.71, green: 0.56, blue: 0.68), location: 0.21),
                        Gradient.Stop(color: Color(red: 0.53, green: 0.75, blue: 0.82), location: 0.37),
                        Gradient.Stop(color: Color(red: 0.64, green: 0.75, blue: 0.55), location: 0.65),
                        Gradient.Stop(color: Color(red: 0.92, green: 0.8, blue: 0.55), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.32, y: 0.07),
                    endPoint: UnitPoint(x: 0.98, y: 0.99))
                .opacity(0.5)
                .ignoresSafeArea(.all)

                VStack {
                    Image("harmonyaLogo")
                        .padding(.top, -29)
                        .padding()

                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                currentCycleIndex = (currentCycleIndex - 1 + cyclesViewModel.cycles.count) % cyclesViewModel.cycles.count
                            }
                        }) {
                            Image(systemName: "arrowshape.left.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.black)
                        }

                        Spacer().frame(width: 300)

                        Button(action: {
                            withAnimation {
                                currentCycleIndex = (currentCycleIndex + 1) % cyclesViewModel.cycles.count
                            }
                        }) {
                            Image(systemName: "arrowshape.right.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }

                    VStack {
                        if !cyclesViewModel.cycles.isEmpty {
                            let cycle = cyclesViewModel.cycles[currentCycleIndex]
                            ZStack {
                                Ellipse()
                                    .frame(width: 388, height: 280)
                                    .rotationEffect(.degrees(6))
                                    .foregroundStyle(cycle.lightColor)

                                VStack {
                                    Text("Cycle \(cycle.name)")
                                        .lineLimit(4)
                                        .font(.PlayfairDisplaySC.black(size: 30))
                                        .multilineTextAlignment(.center)
                                        .padding(.top,20)

                                    Text(cycle.name == "Genre Masculin" ? "\(cycle.duration) heures" : "\(cycle.duration) jours")
                                        .font(.PlayfairDisplaySC.bold(size: 28))
                                        .foregroundStyle(.white)
                                }
                                .background(
                                    Ellipse()
                                        .frame(width: 320, height: 265)
                                        .rotationEffect(.degrees(6))
                                        .foregroundStyle(cycle.darkColor)
                                        .padding()
                                )
                                .padding(.bottom, 104)
                            }

                            Button(action: {
                                Task {
                                    await addCycleEvents(cycle)
                                }
                            }, label: {
                                Text("Ajouter le cycle \(cycle.name)")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background {
                                        Rectangle()
                                            .cornerRadius(10)
                                            .foregroundColor(.sunset)
                                    }
                            })

                            ForEach(cycle.texts, id: \.self) { text in
                                Text(text.title)
                                    .font(.title2)
                                    .multilineTextAlignment(.leading)
                                    .bold()
                                Text(text.text)
                            }
                            .padding()
                        } else {
                            ProgressView("Chargement des cycles...")
                                .padding()
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showWelcomeView) {
            WelcomeView()
        }
        .onAppear {
            Task {
                await cyclesViewModel.fetchCycles()
            }
        }
    }

    // MARK: - Fonction pour ajouter les events du cycle sur le serveur
    private func addCycleEvents(_ cycle: Cycle) async {
        if !userViewModel.currentUser.cycles.contains(cycle.name) {
            userViewModel.currentUser.addCycle(cycle.name)
            
            // Mettre à jour les cycles sur le serveur
            await userViewModel.updateUserCyclesOnServer()
            
            let calendar = Calendar.current
            let baseDate = Date()

            switch cycle.name {
            case "Genre Féminin":
                showWelcomeView.toggle()

            case "Lunaire":
                await addLunarCycleEvents(baseDate: baseDate, calendar: calendar)

            case "Saisonnier":
                await addSeasonalCycleEvents(baseDate: baseDate, calendar: calendar)

            case "Genre Masculin":
                await addMasculinCycleEvents(baseDate: baseDate, calendar: calendar)

            default:
                break
            }
        }
    }

    // MARK: - Fonctions d'ajout spécifiques pour chaque cycle

    private func addLunarCycleEvents(baseDate: Date, calendar: Calendar) async {
        let lastNewMoonDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 20))!
        let lunarCycleLength: Double = 29.5
        let lunarPhases: [(phase: String, symbol: String, color: Color)] = [
            ("Nouvelle Lune", "🌑", .black),
            ("Premier Croissant", "🌒", .yellow),
            ("Premier Quartier", "🌓", .blue),
            ("Lune Gibbeuse Croissante", "🌔", .purple),
            ("Pleine Lune", "🌕", .white),
            ("Lune Gibbeuse Décroissante", "🌖", .gray),
            ("Dernier Quartier", "🌗", .green),
            ("Dernier Croissant", "🌘", .mint)
        ]

        for day in 0..<365 {
            let lunarDay = day % Int(lunarCycleLength)
            var currentPhase = lunarPhases[0]

            if lunarDay < 1 { currentPhase = lunarPhases[0] }
            else if lunarDay < 7 { currentPhase = lunarPhases[1] }
            else if lunarDay < 14 { currentPhase = lunarPhases[2] }
            else if lunarDay < 21 { currentPhase = lunarPhases[3] }
            else if lunarDay < 22 { currentPhase = lunarPhases[4] }
            else if lunarDay < 27 { currentPhase = lunarPhases[5] }
            else if lunarDay < 28 { currentPhase = lunarPhases[6] }
            else { currentPhase = lunarPhases[7] }

            let dateForEvent = calendar.date(byAdding: .day, value: day, to: lastNewMoonDate)!
            let calendarWithTime = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: dateForEvent)!
            let event = Event(userId: userViewModel.currentUser.id, title: "Cycle Lunaire", date: calendarWithTime, description: currentPhase.phase, symbol: currentPhase.symbol, color: currentPhase.color)

            await calendarManager.addEventOnServer(event)
            await calendarManager.loadEvents(for: userViewModel.currentUser.id)
        }
    }

    private func addSeasonalCycleEvents(baseDate: Date, calendar: Calendar) async {
        let seasonalPhases: [(season: String, symbol: String, color: Color)] = [
            ("Printemps - Éveil de la nature", "🌱", .green),
            ("Été - Saison de la chaleur", "☀️", .yellow),
            ("Automne - Récolte et transformation", "🍂", .orange),
            ("Hiver - Repos et réflexion", "❄️", .blue)
        ]

        for day in 0..<365 {
            if let dateForEvent = calendar.date(byAdding: .day, value: day, to: baseDate) {
                let month = calendar.component(.month, from: dateForEvent)
                let dayOfMonth = calendar.component(.day, from: dateForEvent)
                var currentSeason = seasonalPhases[3] // default Hiver

                if (month == 3 && dayOfMonth >= 21) || (month > 3 && month < 6) || (month == 6 && dayOfMonth < 22) { currentSeason = seasonalPhases[0] }
                else if (month == 6 && dayOfMonth >= 22) || (month > 6 && month < 9) || (month == 9 && dayOfMonth < 22) { currentSeason = seasonalPhases[1] }
                else if (month == 9 && dayOfMonth >= 22) || (month > 9 && month < 12) || (month == 12 && dayOfMonth < 22) { currentSeason = seasonalPhases[2] }

                let calendarWithTime = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: dateForEvent)!
                let event = Event(userId: userViewModel.currentUser.id, title: "Cycle Saisonnier", date: calendarWithTime, description: currentSeason.season, symbol: currentSeason.symbol, color: currentSeason.color)

                await calendarManager.addEventOnServer(event)
                await calendarManager.loadEvents(for: userViewModel.currentUser.id)
            }
        }
    }

    private func addMasculinCycleEvents(baseDate: Date, calendar: Calendar) async {
        let messages: [(title: String, symbol: String, color: Color, hour: Int)] = [
            ("Pic de testostérone du matin - Énergie maximale", "💥", .orange, 6),
            ("Concentration et performance physique", "💪", .green, 9),
            ("Énergie stable, concentration créative", "🧠", .blue, 12),
            ("Énergie modérée, activité sociale", "😌", .purple, 15),
            ("Baisse d'énergie, relaxation", "🌙", .mint, 18),
            ("Régénération nocturne", "🛏️", .gray, 22)
        ]

        for day in 0..<365 {
            for phase in messages {
                if let dateForEvent = calendar.date(byAdding: .day, value: day, to: baseDate) {
                    let calendarWithTime = calendar.date(bySettingHour: phase.hour, minute: 0, second: 0, of: dateForEvent)!
                    let event = Event(userId: userViewModel.currentUser.id, title: "Cycle masculin", date: calendarWithTime, description: "\(phase.hour)h - \(phase.title)", symbol: phase.symbol, color: phase.color)

                    await calendarManager.addEventOnServer(event)
                    await calendarManager.loadEvents(for: userViewModel.currentUser.id)
                }
            }
        }
    }
}


#Preview {
    CyclesMenuView()
        .environmentObject(UserViewModel())
        .environmentObject(CalendarManager())
}
