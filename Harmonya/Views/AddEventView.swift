//
//  AddEventView.swift
//  HarmonyaCyrcleCycle
//
//  Created by Klesya on 5/13/25.
//

import SwiftUI

struct AddEventView: View {
    var date: Date
    @EnvironmentObject var manager: CalendarManager
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var description = ""
    @State private var symbol = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("📅 Date sélectionnée")) {
                    Text(formattedDate(date))
                        .foregroundColor(.secondary)
                }
                
                Section(header: Text("Symbol")) {
                    TextField("Entrez un symbole", text: $symbol)
                }
                
                Section(header: Text("Titre")) {
                    TextField("Entrez un titre", text: $title)
                }

                Section(header: Text("Description")) {
                    TextField("Entrez une description", text: $description)
                }
            }
            .navigationTitle("Nouvel événement")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        let newEvent = Event(
                            userId: userViewModel.currentUser.id,
                            title: title,
                            date: date,
                            description: description,
                            symbol: symbol,
                            color: .orange
                        )

                        Task {
                            // 1️⃣ Envoi au serveur
                            await manager.addEventOnServer(newEvent)
                            // 2️⃣ Recharge les events pour persistance côté UI
                            await manager.loadEvents(for: userViewModel.currentUser.id)
                        }

                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}


#Preview {
    AddEventView(date: Date())
        .environmentObject(CalendarManager())
        .environmentObject(UserViewModel())
}
