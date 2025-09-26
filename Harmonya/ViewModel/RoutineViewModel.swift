//
//  RoutineViewModel.swift
//  Harmonya
//
//  Created by Klesya on 9/23/25.
//

import Foundation
import Combine

import SwiftUI

@MainActor
class RoutineViewModel: ObservableObject {
    @Published var routines: [Routine] = []
    private let baseURL = "http://127.0.0.1:8080/routines"
    
    func fetchRoutines() {
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
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                print("❌ Erreur HTTP: 401 Unauthorized")
                return
            }
            
            if let error = error {
                print("❌ Error fetching routines: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("❌ No data received from server")
                return
            }
            
            do {
                let decoded = try decoder.decode([Routine].self, from: data)
                DispatchQueue.main.async {
                    self.routines = decoded
                }
            } catch {
                print("❌ Failed to decode routines: \(error)")
            }
        }.resume()
    }

    
    func addRoutine(routine: Routine) async {
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
            request.httpBody = try encoder.encode(routine)
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 || httpResponse.statusCode == 200 {
                fetchRoutines() // Rafraîchir la liste après ajout
            } else {
                print("❌ Erreur HTTP lors de l'ajout: \(response)")
            }
        } catch {
            print("❌ Erreur ajout routine: \(error.localizedDescription)")
        }
    }
    
    func removeRoutine(routineId: UUID) async {
        guard let token = KeychainManager.getTokenFromKeychain() else {
            print("❌ Token manquant, impossible de supprimer la routine")
            return
        }

        guard let url = URL(string: "http://127.0.0.1:8080/routines/\(routineId)") else {
            print("❌ URL invalide")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("✅ Routine supprimée côté serveur")
                fetchRoutines() // Mettre à jour la liste après suppression
            } else {
                print("❌ Erreur serveur lors de la suppression")
            }
        } catch {
            print("❌ Erreur réseau: \(error)")
        }
    }
}
