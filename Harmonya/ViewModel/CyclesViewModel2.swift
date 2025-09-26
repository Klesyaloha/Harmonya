//
//  CyclesViewModel2.swift
//  Harmonya
//
//  Created by Klesya on 7/1/25.
//

import Foundation
import SwiftUI

@MainActor
class CyclesViewModel2: ObservableObject {
    @Published var cycles: [Cycle] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    /// Récupère tous les cycles depuis l’API backend
    func fetchCycles() async {
        print("📡 Début du fetch des cycles...")
        isLoading = true
        errorMessage = nil

        do {
            guard let url = URL(string: "http://127.0.0.1:8080/cycles") else {
                print("❌ URL invalide")
                throw URLError(.badURL)
            }

            print("🌍 URL créée : \(url)")

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            print("📤 Requête envoyée : \(request)")

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Réponse invalide (pas de HTTPURLResponse)")
                throw URLError(.badServerResponse)
            }

            print("📥 Statut HTTP : \(httpResponse.statusCode)")

            guard httpResponse.statusCode == 200 else {
                print("❌ Statut HTTP inattendu : \(httpResponse.statusCode)")
                throw URLError(.badServerResponse)
            }

            // 🧪 Affiche la réponse brute
            if let jsonString = String(data: data, encoding: .utf8) {
                print("🧾 JSON reçu brut :\n\(jsonString)")
            } else {
                print("⚠️ Impossible d'afficher le JSON sous forme de String.")
            }

            let decodedCycles = try JSONDecoder().decode([Cycle].self, from: data)

            print("✅ Décodage JSON réussi. Nombre de cycles : \(decodedCycles.count)")

            DispatchQueue.main.async {
                self.cycles = decodedCycles
                print("🧠 Cycles mis à jour dans la vue.")
            }

        } catch {
            self.errorMessage = "❌ Impossible de charger les cycles : \(error.localizedDescription)"
            print("🛑 Erreur lors du fetch : \(error)")
        }

        isLoading = false
        print("🔁 Fin du fetch.")
    }

}

