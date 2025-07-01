//
//  WelcomeView.swift
//  Harmonya
//
//  Created by Klesya on 6/11/25.
//

import SwiftUI

struct WelcomeView: View {
    @State var name = ""
    @State var startDate: Date = Date()
    @State var duration: Int = 7
    @State private var navigateToCalendar = false

    @StateObject var calendarManager = CalendarManager()
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField(text: $name, label: {
                    Text("Your Name")
                })
                .padding(.leading, 45)
                .background {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 339, height: 70)
                        .background(Color(red: 0.75, green: 0.6, blue: 0.65))
                    
                        .cornerRadius(36)
                }
                .padding()
                
                Spacer().frame(height: 20)
                
                DatePicker(
                    "Date de début de règles",
                    selection: $startDate,
                    displayedComponents: [.date]
                )
                .padding(.horizontal, 30)
                .datePickerStyle(.compact)
                
                Spacer().frame(height: 20)
                
                Stepper(value: $duration, in: 1...10) {
                    Text("Durée des règles : \(duration) jours")
                }
                .padding(.horizontal, 30)
                
                Button(action: {
                    let baseDate = Date()
                    let calendar = Calendar.current
                    
                    let reglesDuration = duration
                    let folliculaireDuration = 13 - reglesDuration // car 5 jours de règles déjà comptés (1 à 13 au total)
                    let ovulationDay = 14
                    let lutealeDuration = 14
                    
                    // 🩸 Phase menstruelle (Jours 1 à 5)
                    for i in 0..<reglesDuration {
                        if let date = calendar.date(byAdding: .day, value: i, to: baseDate) {
                            calendarManager.addEvent(Event(title: "Phase menstruelle", date: date, description: "Jour \(i + 1)", symbol: "🩸", color: .red))
                        }
                    }
                    
                    // 🌱 Phase folliculaire (Jours 6 à 13)
                    for i in 0..<folliculaireDuration {
                        if let date = calendar.date(byAdding: .day, value: i + reglesDuration, to: baseDate) {
                            calendarManager.addEvent(Event(title: "Phase folliculaire", date: date, description: "Jour \(i + 1)", symbol: "🌱", color: .green))
                        }
                    }
                    
                    // 🥚 Ovulation (Jour 14)
                    if let date = calendar.date(byAdding: .day, value: ovulationDay - 1, to: baseDate) {
                        calendarManager.addEvent(Event(title: "Phase ovulatoire", date: date, description: "Jour 1", symbol: "🥚", color: .accent))
                    }
                    
                    // 🌙 Phase lutéale (Jours 15 à 28)
                    for i in 0...lutealeDuration {
                        if let date = calendar.date(byAdding: .day, value: i + ovulationDay, to: baseDate) {
                            calendarManager.addEvent(Event(title: "Phase lutéale", date: date, description: "Jour \(i + 1)", symbol: "🌙", color: .sunset))
                        }
                    }
                    
                    navigateToCalendar = true
                }, label: {
                    Text("Confirmer")
                })
                .buttonStyle(BorderedProminentButtonStyle())
                .padding()
                .navigationDestination(isPresented: $navigateToCalendar) {
                    CalendarView(calendarManager: calendarManager)
                        .navigationBarBackButtonHidden()
                }
            }
        }
        
    }
}

#Preview {
    WelcomeView()
}
