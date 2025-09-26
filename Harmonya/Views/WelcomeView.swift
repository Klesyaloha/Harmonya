//
//  WelcomeView.swift
//  Harmonya
//
//  Created by Klesya on 6/11/25.
//

import SwiftUI

struct WelcomeView: View {
    @State var startDate: Date = Date()
    @State var duration: Int = 7
    @State private var isSaving = false

    @EnvironmentObject var calendarManager: CalendarManager
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // 🌿 Fond dégradé doux et harmonieux
            LinearGradient(colors: [Color.lilac.opacity(0.4), Color.skyBlue.opacity(0.3), Color.olivine.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 25) {
                Text("Ajouter un cycle de menstruation")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
                    .padding(.top, 20)

                VStack(spacing: 20) {
                    // 📅 DatePicker
                    DatePicker("Date de début de règles", selection: $startDate, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .accentColor(.sunset)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
                        )

                    // ⏱️ Durée des règles
                    Stepper("Durée des règles : \(duration) jours", value: $duration, in: 1...10)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
                        )
                }
                .padding(.horizontal, 30)

                // ✅ Bouton Confirmer
                Button {
                    Task { await saveCycleEvents() }
                } label: {
                    HStack {
                        if isSaving {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Confirmer")
                                .fontWeight(.semibold)
                                .font(.title3)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(colors: [Color.sunset, Color.skyBlue], startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 3)
                    .foregroundColor(.white)
                }
                .disabled(isSaving)
                .padding(.horizontal, 30)

                Spacer()
            }
            .padding(.bottom, 20)
        }
    }
    
    // MARK: - Ajout des events
    private func saveCycleEvents() async {
        isSaving = true
        
        let calendar = Calendar.current
        let baseDate = startDate
        let reglesDuration = duration
        let folliculaireDuration = 13 - reglesDuration
        let ovulationDay = 14
        let lutealeDuration = 14
        
        // 📌 Phase menstruelle
        for i in 0..<reglesDuration {
            if let date = calendar.date(byAdding: .day, value: i, to: baseDate) {
                let event = Event(userId: userViewModel.currentUser.id,
                                  title: "Phase menstruelle",
                                  date: date,
                                  description: "Jour \(i + 1)",
                                  symbol: "🩸",
                                  color: .red)
                await calendarManager.addEventOnServer(event)
            }
        }
        
        // 🌱 Phase folliculaire
        for i in 0..<folliculaireDuration {
            if let date = calendar.date(byAdding: .day, value: i + reglesDuration, to: baseDate) {
                let event = Event(userId: userViewModel.currentUser.id,
                                  title: "Phase folliculaire",
                                  date: date,
                                  description: "Jour \(i + 1)",
                                  symbol: "🌱",
                                  color: .green)
                await calendarManager.addEventOnServer(event)
            }
        }
        
        // 🥚 Ovulation
        if let date = calendar.date(byAdding: .day, value: ovulationDay - 1, to: baseDate) {
            let event = Event(userId: userViewModel.currentUser.id,
                              title: "Phase ovulatoire",
                              date: date,
                              description: "Jour 1",
                              symbol: "🥚",
                              color: .accent)
            await calendarManager.addEventOnServer(event)
        }
        
        // 🌙 Phase lutéale
        for i in 0..<lutealeDuration {
            if let date = calendar.date(byAdding: .day, value: i + ovulationDay, to: baseDate) {
                let event = Event(userId: userViewModel.currentUser.id,
                                  title: "Phase lutéale",
                                  date: date,
                                  description: "Jour \(i + 1)",
                                  symbol: "🌙",
                                  color: .sunset)
                await calendarManager.addEventOnServer(event)
            }
        }
        
        // Recharge les events
        await calendarManager.loadEvents(for: userViewModel.currentUser.id)
        
        isSaving = false
        dismiss()   // 👈 ferme l’overlay automatiquement
    }
}


#Preview {
    let calendarManager = CalendarManager()
    let userViewModel = UserViewModel()
    WelcomeView()
        .environmentObject(calendarManager)
        .environmentObject(userViewModel)
}

