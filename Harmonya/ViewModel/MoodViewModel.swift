//
//  MoodViewModel.swift
//  Harmonya
//
//  Created by Klesya on 9/23/25.
//

import Foundation
import Combine

class MoodViewModel: ObservableObject {
    @Published var moods: [Mood] = []
    private let baseURL = "http://localhost:8080/moods"
    private var userViewModel = UserViewModel()

    func fetchMoods() {
        guard let url = URL(string: "\(baseURL)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Récupérer le token
        guard let token = KeychainManager.getTokenFromKeychain() else {
            print("❌ Token manquant")
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // ✅ Important
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("❌ Error fetching journals: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("❌ No data received from server")
                return
            }
            
            do {
                // Decode Journal depuis JSON
                let decoded = try decoder.decode([Mood].self, from: data)
                
                DispatchQueue.main.async {
                    self.moods = decoded
                }
            } catch {
                print("❌ Failed to decode journals: \(error)")
                if let jsonStr = String(data: data, encoding: .utf8) {
                    print("📄 RAW JSON: \(jsonStr)")
                }
            }
        }.resume()
    }

    func addMood(mood: Mood) async {
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 🔑 Ajouter le token
        if let token = KeychainManager.getTokenFromKeychain() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            request.httpBody = try encoder.encode(mood)
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 || httpResponse.statusCode == 200 {
                fetchMoods() // Rafraîchir la liste après ajout
            } else {
                print("❌ Erreur HTTP lors de l'ajout: \(response)")
            }
        } catch {
            print("❌ Erreur ajout emotion: \(error.localizedDescription)")
        }
    }

    func removeMood(moodId: UUID) async {
        guard let token = KeychainManager.getTokenFromKeychain() else {
            print("❌ Token manquant, impossible de supprimer la routine")
            return
        }

        guard let url = URL(string: "http://127.0.0.1:8080/moods/\(moodId)") else {
            print("❌ URL invalide")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("✅ Emotion supprimée côté serveur")
                fetchMoods() // Mettre à jour la liste après suppression
            } else {
                print("❌ Erreur serveur lors de la suppression")
            }
        } catch {
            print("❌ Erreur réseau: \(error)")
        }
    }
}
