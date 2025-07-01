//
//  AddEventView.swift
//  HarmonyaCyrcleCycle
//
//  Created by Klesya on 5/13/25.
//

import SwiftUI

struct AddEventView: View {
    var date: Date
    @ObservedObject var manager: CalendarManager
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
                        let event = Event(title: title, date: date, description: description, symbol: symbol, color: .orange)
                        manager.addEvent(event)
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


//#Preview {
//    AddEventView()
//}
