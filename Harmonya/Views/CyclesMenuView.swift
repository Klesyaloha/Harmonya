//
//  CyclesMenuView.swift
//  CalendarApp
//
//  Created by Klesya on 5/14/25.
//

import SwiftUI

struct CyclesMenuView: View {
    var cyclesViewModel = CyclesViewModel()
    var calendarManager: CalendarManager
    @StateObject var userViewModel: UserViewModel
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
                        .padding(.top, -29.121)
                        .padding()
                    
                    HStack {
                        Spacer()

                        Button(action: {
                            withAnimation {
                                currentCycleIndex = (currentCycleIndex - 1 + cyclesViewModel.cycles.count) % cyclesViewModel.cycles.count
                            }
                        }, label: {
                            Image(systemName: "arrowshape.left.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.black)
                        })

                        Spacer()
                            .frame(width: 300.0)

                        Button(action: {
                            withAnimation {
                                currentCycleIndex = (currentCycleIndex + 1) % cyclesViewModel.cycles.count
                            }
                        }, label: {
                            Image(systemName: "arrowshape.right.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.black)
                        })

                        Spacer()
                    }
                    .foregroundStyle(.black)
                    
                    VStack {
                        let cycle = cyclesViewModel.cycles[currentCycleIndex]
                        ZStack {
                            Ellipse()
                                .frame(width: 388, height: 280)
                                .rotationEffect(.degrees(6))
                                .foregroundStyle(cycle.lightSwiftUIColor)
                            
                            VStack {
                                Text("Cycle \(cycle.name)")
                                    .lineLimit(4)
                                    .font(.PlayfairDisplaySC.black(size: 30))
                                    .multilineTextAlignment(.center)
                                    .padding(.top,20.0)
                                
                                Text(cycle.name == "Genre Masculin" ? "\(cycle.duration) heures" :"\(cycle.duration) jours")
                                    .font(.PlayfairDisplaySC.bold(size: 28))
                                    .foregroundStyle(.white)
                            }
                            .background(
                                Ellipse()
                                    .frame(width: 320.0, height: 265.0)
                                    .rotationEffect(.degrees(6))
                                    .foregroundStyle(cycle.darkSwiftUIColor)
                                    .padding()
                            )
                            .padding(.bottom, 104.197)
                        }
                        
                        Button(action: {
                            if cycle.name == "Genre Féminin" && !userViewModel.currentUser.cycles.contains(where: { $0.name == "Genre Féminin" }) {
                                showWelcomeView.toggle()
                                userViewModel.currentUser.addCycle(cyclesViewModel.cycles.first(where: { $0.name == "Genre Féminin" })!)
                            }
                            
                            if cycle.name == "Lunaire" && !userViewModel.currentUser.cycles.contains(where: { $0.name == "Lunaire" }){
                                userViewModel.currentUser.addCycle(cyclesViewModel.cycles.first(where: { $0.name == "Lunaire" })!)
                                // Définir la date de la dernière Nouvelle Lune (exemple, à ajuster pour la précision)
                                let calendar = Calendar.current
                                
                                // La date de la dernière Nouvelle Lune connue (exemple : 2025-03-20)
                                // Remplace-la par la vraie date de la prochaine Nouvelle Lune ou d'une date approximative.
                                let lastNewMoonDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 20))!
                                
                                // Durée du cycle lunaire (en jours)
                                let lunarCycleLength: Double = 29.5
                                
                                // Phases lunaires à associer à chaque jour du cycle
                                let lunarPhases: [(phase: String, symbol: String, color: Color)] = [
                                    ("Nouvelle Lune", "🌑", .black),   // 0 - 1er jour (Nouvelle Lune)
                                    ("Premier Croissant", "🌒", .yellow), // 1 à 7 jours
                                    ("Premier Quartier", "🌓", .blue),  // 7 à 14 jours
                                    ("Lune Gibbeuse Croissante", "🌔", .purple), // 14 à 21 jours
                                    ("Pleine Lune", "🌕", .white),  // 21 à 22 jours
                                    ("Lune Gibbeuse Décroissante", "🌖", .gray),  // 22 à 27 jours
                                    ("Dernier Quartier", "🌗", .green), // 27 à 28 jours
                                    ("Dernier Croissant", "🌘", .mint)  // 28 à 29,5 jours
                                ]
                                
                                // Répétition du cycle lunaire tous les 29,5 jours pendant toute l'année (365 jours)
                                let totalDays = 365  // Nombre de jours dans l'année
                                
                                for day in 0..<totalDays {
                                    // Calculer le jour du cycle lunaire actuel en fonction de la date de la dernière Nouvelle Lune
                                    let lunarDay = day % Int(lunarCycleLength)  // Cycle lunaire sur 29,5 jours
                                    
                                    // Calculer la phase lunaire du jour en fonction de la Nouvelle Lune
                                    var currentPhase: (phase: String, symbol: String, color: Color) = ("", "", .black)
                                    
                                    // Déterminer la phase lunaire actuelle
                                    if lunarDay < 1 {
                                        currentPhase = lunarPhases[0]  // Nouvelle Lune
                                    } else if lunarDay < 7 {
                                        currentPhase = lunarPhases[1]  // Premier Croissant
                                    } else if lunarDay < 14 {
                                        currentPhase = lunarPhases[2]  // Premier Quartier
                                    } else if lunarDay < 21 {
                                        currentPhase = lunarPhases[3]  // Lune Gibbeuse Croissante
                                    } else if lunarDay < 22 {
                                        currentPhase = lunarPhases[4]  // Pleine Lune
                                    } else if lunarDay < 27 {
                                        currentPhase = lunarPhases[5]  // Lune Gibbeuse Décroissante
                                    } else if lunarDay < 28 {
                                        currentPhase = lunarPhases[6]  // Dernier Quartier
                                    } else {
                                        currentPhase = lunarPhases[7]  // Dernier Croissant
                                    }
                                    
                                    // Calculer la date exacte pour cet événement lunaire
                                    let dateForEvent = calendar.date(byAdding: .day, value: day, to: lastNewMoonDate)!
                                    
                                    // Calculer l'heure de l'événement pour chaque phase
                                    let hour = 12 // L'heure à laquelle l'événement est enregistré (peut être ajustée)
                                    let minute = 0
                                    
                                    let calendarWithTime = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: dateForEvent)!
                                    
                                    // Ajouter l'événement pour la phase lunaire correspondante
                                    calendarManager.addEvent(Event(
                                        title: "Cycle Lunaire",
                                        date: calendarWithTime,
                                        description: "\(currentPhase.phase)",  // Affiche l'heure avant la phase
                                        symbol: currentPhase.symbol,
                                        color: currentPhase.color
                                    ))
                                }
                            }
                            
                            if cycle.name == "Saisonnier" && !userViewModel.currentUser.cycles.contains(where: { $0.name == "Saisonnier" }) {
                                userViewModel.currentUser.addCycle(cyclesViewModel.cycles.first(where: { $0.name == "Saisonnier" })!)
                                let baseDate = Date()  // Date actuelle
                                let calendar = Calendar.current
                                
                                // Les événements saisonniers avec des messages et des couleurs associés à chaque saison
                                let seasonalPhases: [(season: String, symbol: String, color: Color)] = [
                                    ("Printemps - Éveil de la nature", "🌱", .green),   // 21 Mars au 21 Juin
                                    ("Été - Saison de la chaleur", "☀️", .yellow),     // 22 Juin au 21 Septembre
                                    ("Automne - Récolte et transformation", "🍂", .orange), // 22 Septembre au 21 Décembre
                                    ("Hiver - Repos et réflexion", "❄️", .blue)        // 22 Décembre au 20 Mars
                                ]
                                
                                // Répétition du cycle saisonnier pendant toute l'année (365 jours)
                                let totalDays = 365  // Nombre de jours dans l'année
                                
                                for day in 0..<totalDays {
                                    // Calculer la date du jour dans l'année
                                    if let dateForEvent = calendar.date(byAdding: .day, value: day, to: baseDate) {
                                        let month = calendar.component(.month, from: dateForEvent) // Récupérer le mois du jour
                                        let dayOfMonth = calendar.component(.day, from: dateForEvent) // Récupérer le jour du mois
                                        
                                        var currentSeason: (season: String, symbol: String, color: Color) = ("", "", .black)
                                        
                                        // Associer la saison en fonction du mois et du jour
                                        if (month == 3 && dayOfMonth >= 21) || (month > 3 && month < 6) || (month == 6 && dayOfMonth < 22) {  // Printemps
                                            currentSeason = seasonalPhases[0]
                                        } else if (month == 6 && dayOfMonth >= 22) || (month > 6 && month < 9) || (month == 9 && dayOfMonth < 22) {  // Été
                                            currentSeason = seasonalPhases[1]
                                        } else if (month == 9 && dayOfMonth >= 22) || (month > 9 && month < 12) || (month == 12 && dayOfMonth < 22) {  // Automne
                                            currentSeason = seasonalPhases[2]
                                        } else {  // Hiver
                                            currentSeason = seasonalPhases[3]
                                        }
                                        
                                        // Calculer l'heure de l'événement pour chaque saison
                                        let hour = 12 // L'heure à laquelle l'événement est enregistré (peut être ajustée)
                                        let minute = 0
                                        
                                        let calendarWithTime = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: dateForEvent)!
                                        
                                        // Ajouter l'événement pour la saison correspondante
                                        calendarManager.addEvent(Event(
                                            title: "Cycle Saisonnier",
                                            date: calendarWithTime,
                                            description: "\(currentSeason.season)",  // Affiche l'heure avant la saison
                                            symbol: currentSeason.symbol,
                                            color: currentSeason.color
                                        ))
                                    }
                                }
                            }
                            
                            if cycle.name == "Genre Masculin" && !userViewModel.currentUser.cycles.contains(where: { $0.name == "Genre Masculin" }){
                                userViewModel.currentUser.addCycle(cyclesViewModel.cycles.first(where: { $0.name == "Genre Masculin" })!)
                                let baseDate = Date()  // Date actuelle
                                let calendar = Calendar.current
                                
                                // Les événements à répéter chaque jour avec les horaires
                                let messages: [(title: String, symbol: String, color: Color, hour: Int)] = [
                                    ("Pic de testostérone du matin - Énergie maximale", "💥", .orange, 6),   // 6h
                                    ("Concentration et performance physique", "💪", .green, 9),            // 9h
                                    ("Énergie stable, concentration créative", "🧠", .blue, 12),            // 12h
                                    ("Énergie modérée, activité sociale", "😌", .purple, 15),              // 15h
                                    ("Baisse d'énergie, relaxation", "🌙", .mint, 18),                     // 18h
                                    ("Régénération nocturne", "🛏️", .gray, 22)                            // 22h
                                ]
                                
                                // Répétition de ce cycle tous les jours pendant toute l'année (365 jours)
                                let totalDays = 365  // Nombre de jours dans l'année
                                
                                for day in 0..<totalDays {
                                    for phase in messages {
                                        // Calculer la date et l'heure pour chaque phase
                                        let hour = phase.hour
                                        let minute = 0 // On fixe les minutes à 00 pour simplifier

                                        if let dateForEvent = calendar.date(byAdding: .day, value: day, to: baseDate) {
                                            let calendarWithTime = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: dateForEvent)!
                                            
                                            calendarManager.addEvent(Event(
                                                title: "Cycle masculin",
                                                date: calendarWithTime,
                                                description: "\(hour)h - \(phase.title)",  // Affiche l'heure avant le message
                                                symbol: phase.symbol,
                                                color: phase.color
                                            ))
                                        }
                                    }
                                }
                            }

                        }, label: {
                            Text("Ajouter le cycle \(cycle.name)")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding()
                                .background{
                                    Rectangle()
                                        .cornerRadius(10)
                                        .foregroundColor(.sunset)
                                }
                        })
                        
                        ForEach(cycle.texts) { text in
                            Text(text.title)
                                .font(.title2)
                                .multilineTextAlignment(.leading)
                                .bold()
                            Text(text.text)
                        }
                        .padding()
                    }
                }
            }
        }.sheet(isPresented: $showWelcomeView, content: {
            WelcomeView(calendarManager: calendarManager)
        })
    }
}

#Preview {
    CyclesMenuView(calendarManager: CalendarManager(), userViewModel: UserViewModel())
}
