//
//  LoginViewModel.swift
//  ZakFit
//
//  Created by Klesya on 10/12/2024.
//

import Foundation
import Security
import SwiftUI

class UserViewModel: ObservableObject, @unchecked Sendable {
//    @Published var currentUser = User(nameUser: "Klesya", email: "klesya@test.fr", password: "test", cycles: [])
    @Published var currentUser = User(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, nameUser: "", email: "", password: "", cycles: [])
    @Published var originalUser: User?
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isLoggedIn = false
    @Published var isLoadingUser = true
    @Published var loginError: String? = nil // Message d'erreur éventuel
    @Published var registrationError: String? = nil // Erreur d'inscription
    @Published var isRegistered: Bool = false // Statut d'inscription
    
    @Published var showUpdateAlert: Bool = false  // Contrôler l'affichage de l'alerte
    @Published var alertUpdateMessage: String = "" // Message à afficher dans l'alerte
    
    private let baseURL = "http://127.0.0.1:8080/users/"
    
    func login() async {
        guard let url = URL(string: "\(baseURL)login") else {
            DispatchQueue.main.async {
                self.loginError = "URL invalide."
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let authData = ("\(currentUser.email):\(currentUser.password ?? "")").data(using: .utf8)?.base64EncodedString() else {
            DispatchQueue.main.async {
                self.loginError = "Erreur lors du codage des identifiants."
            }
            return
        }
        request.addValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.loginError = "Identifiants incorrects ou erreur serveur."
                }
                return
            }
            
            // Décoder la réponse contenant le token et l'utilisateur
            let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
            
            // Sauvegarder le token dans le Keychain
            guard KeychainManager.saveTokenToKeychain(loginResponse.token) else {
                DispatchQueue.main.async {
                    self.loginError = "Impossible de sauvegarder le token."
                }
                return
            }
            // Mettre à jour les données de l'utilisateur dans le ViewModel
            DispatchQueue.main.async {
                self.currentUser = loginResponse.user
                self.originalUser = self.currentUser.copy()
                self.isLoggedIn = true
                self.loginError = nil
                UserDefaults.standard.set(loginResponse.user.id.uuidString, forKey: "currentUserId")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
            }
        } catch {
            DispatchQueue.main.async {
                self.loginError = "Erreur: \(error.localizedDescription)"
            }
        }
    }
    
    func fetchUserData(userID: UUID) async {
        guard let url = URL(string: "\(baseURL)\(userID.uuidString)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let token = KeychainManager.getTokenFromKeychain() else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("⚠️ Erreur HTTP : \(httpResponse.statusCode)")
                return
            }
            
            // Décoder JSON **sans ID**
            let decoder = JSONDecoder()
            let tempUser = try decoder.decode(TempUser.self, from: data)
            
            DispatchQueue.main.async {
                // Injecter l'ID correct
                self.currentUser = User(
                    id: userID,
                    nameUser: tempUser.nameUser,
                    email: tempUser.email,
                    cycles: tempUser.cycles
                )
                self.originalUser = self.currentUser.copy()
                self.isLoggedIn = true
                print("✅ Utilisateur chargé : \(self.currentUser.nameUser) - ID: \(self.currentUser.id)")
            }
            
        } catch {
            print("⚠️ Erreur fetchUserData : \(error.localizedDescription)")
        }
    }

    // Struct temporaire pour décoder JSON sans ID
    struct TempUser: Decodable {
        let nameUser: String
        let email: String
        let cycles: [String]
    }

    
    func register() async {
        guard let url = URL(string: "\(baseURL)register") else {
            DispatchQueue.main.async {
                self.registrationError = "URL invalide."
            }
            return
        }
        
        // Préparer les données à envoyer
        let userData = PartialUserUpdate(
            nameUser: self.currentUser.nameUser,
            email: self.currentUser.email,
            password: self.currentUser.password,
            cycles: self.currentUser.cycles
        )
        
        do {
            let jsonData = try JSONEncoder().encode(userData)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                DispatchQueue.main.async {
                    self.registrationError = "Échec de l'inscription."
                }
                return
            }
            
            DispatchQueue.main.async {
                self.isRegistered = true
                self.registrationError = nil
            }
        } catch {
            DispatchQueue.main.async {
                self.registrationError = "Erreur: \(error.localizedDescription)"
            }
        }
    }
    
    func logout() {
        print(isLoggedIn)
        KeychainManager.deleteTokenFromKeychain()
        print("Déconnecté. Token supprimé.")
        clearData()
        print("Données locales supprimées.")
        isLoggedIn = false
        print(isLoggedIn)
        UserDefaults.standard.removeObject(forKey: "currentUserId")
        UserDefaults.standard.set(false, forKey: "isLoggedIn") // persistance manuelle
    }
    
    // Fonction pour mettre à jour l'utilisateur
    func updateUserData() async {
        // Initialiser la variable qui stockera les champs modifiés
        var updatedFields = PartialUserUpdate()
        
        // Comparer chaque champ et ajouter uniquement ceux qui ont changé
        if currentUser.nameUser != originalUser?.nameUser {
            updatedFields.nameUser = currentUser.nameUser
        }
        if currentUser.email != originalUser?.email {
            updatedFields.email = currentUser.email
        }
        if currentUser.cycles != originalUser?.cycles {
            updatedFields.cycles = currentUser.cycles
        }
        // Vérification de la connexion avant de commencer la requête
        guard let url = URL(string: "\(baseURL)\(currentUser.id.uuidString)") else {
            errorMessage = "URL invalide"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Récupérer le token depuis le Keychain
        guard let token = KeychainManager.getTokenFromKeychain() else {
            DispatchQueue.main.async {
                self.errorMessage = "Erreur lors de la récupération du token."
            }
            return
        }
        
        // Ajouter le token à l'en-tête Authorization
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Créer un encodeur pour encoder l'objet currentUser
        let encoder = JSONEncoder()
        do {
            let body = try encoder.encode(updatedFields)
            request.httpBody = body
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Erreur d'encodage des données."
            }
            return
        }
        
        do {
            // Effectuer la requête HTTP asynchrone
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Vérifier le statut HTTP de la réponse
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Si le statut est 200, décoder l'utilisateur mis à jour
                let decoder = JSONDecoder()
                if let updatedUser = try? decoder.decode(User.self, from: data) {
                    // Mettre à jour currentUser avec l'utilisateur mis à jour
                    DispatchQueue.main.async {
                        self.currentUser = updatedUser
                        self.originalUser = self.currentUser.copy()
                        self.errorMessage = nil
                        self.alertUpdateMessage = "Vos informations ont été mises à jour avec succès."
                        
                        // Générer un message d'alerte indiquant quels champs ont été modifiés
                        var modifiedFields = [String]()
                        if let _ = updatedFields.nameUser { modifiedFields.append("Nom") }
                        if let _ = updatedFields.surname { modifiedFields.append("Prénom") }
                        if let _ = updatedFields.email { modifiedFields.append("Email") }
                        if let _ = updatedFields.cycles { modifiedFields.append("Cycles") }
                        
                        if !modifiedFields.isEmpty {
                            self.alertUpdateMessage = "Champs modifiés : " + modifiedFields.joined(separator: ", ")
                            print(self.showUpdateAlert)
                            self.objectWillChange.send()
                            self.showUpdateAlert = true // Afficher l'alerte
                            print(self.showUpdateAlert)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Impossible de décoder la réponse."
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Erreur de la requête, statut \(response)"
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Erreur de connexion: \(error.localizedDescription)"
            }
        }
    }
    
    // Réinitialiser les données utilisateur en cas de déconnexion
    func clearData() {
        self.currentUser = User(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, nameUser: "", email: "", password: "", cycles: [])
        self.originalUser = nil
    }
    
    func changePassword(oldPassword: String, newPassword: String) async {
        guard let token = KeychainManager.getTokenFromKeychain(), !token.isEmpty else {
            DispatchQueue.main.async {
                self.errorMessage = "Token manquant. Veuillez vous reconnecter."
                print("❌ Aucun token trouvé dans le Keychain")
            }
            return
        }

        guard let url = URL(string: "\(baseURL)\(currentUser.id.uuidString)/update-password") else {
            DispatchQueue.main.async {
                self.errorMessage = "URL invalide."
                print("❌ URL invalide pour update-password")
            }
            return
        }

        let passwordUpdate = [
            "oldPassword": oldPassword,
            "newPassword": newPassword
        ]

        do {
            let jsonData = try JSONEncoder().encode(passwordUpdate)

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // ✅ token ajouté
            request.httpBody = jsonData

            print("ℹ️ Envoi du mot de passe avec token:", token)
            print("ℹ️ URL:", url)

            let (_, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                print("ℹ️ Statut HTTP reçu:", httpResponse.statusCode)
                DispatchQueue.main.async {
                    if httpResponse.statusCode == 200 {
                        self.alertUpdateMessage = "Mot de passe changé avec succès."
                        self.showUpdateAlert = true
                    } else if httpResponse.statusCode == 401 {
                        self.errorMessage = "Non autorisé. Vérifiez votre connexion."
                    } else {
                        self.errorMessage = "Échec du changement de mot de passe. Statut: \(httpResponse.statusCode)"
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Erreur: \(error.localizedDescription)"
                print("❌ Erreur lors de l'envoi de la requête:", error)
            }
        }
    }
    
    @MainActor
    func updateUserCycles() async {
        guard let url = URL(string: "\(baseURL)\(currentUser.id.uuidString)") else {
            print("❌ URL invalide pour mise à jour des cycles")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Ajouter le token pour autorisation
        if let token = KeychainManager.getTokenFromKeychain() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Créer le corps JSON avec seulement les cycles
        let body: [String: Any] = ["cycles": currentUser.cycles]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("❌ Erreur encodage JSON: \(error)")
            return
        }

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("✅ Cycles mis à jour sur la base de données")
            } else {
                print("❌ Erreur serveur lors de la mise à jour des cycles")
            }
        } catch {
            print("❌ Erreur réseau: \(error)")
        }
    }
    
    @MainActor
    func updateUserCyclesOnServer() async {
        let userId = currentUser.id
        guard let url = URL(string: "\(baseURL)\(userId.uuidString)") else {
            print("❌ URL invalide ou ID manquant")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Ajouter le token pour l'authentification
        if let token = KeychainManager.getTokenFromKeychain() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // Corps JSON : uniquement les cycles
        let body: [String: Any] = ["cycles": currentUser.cycles]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("❌ Erreur lors de l'encodage JSON : \(error)")
            return
        }

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("✅ Cycles mis à jour sur le serveur")
            } else {
                print("❌ Erreur serveur lors de la mise à jour des cycles")
            }
        } catch {
            print("❌ Erreur réseau : \(error)")
        }
    }
    
    @MainActor
    func loadCurrentUserIfLoggedIn() async {
        if UserDefaults.standard.bool(forKey: "isLoggedIn"),
           let idString = UserDefaults.standard.string(forKey: "currentUserId"),
           let userId = UUID(uuidString: idString) {
            
            // Charger les données utilisateur AVANT d’activer la session
            await fetchUserData(userID: userId)
            
            if currentUser.id != UUID(uuidString: "00000000-0000-0000-0000-000000000000") {
                self.isLoggedIn = true
                print("✅ Utilisateur restauré avec succès : \(currentUser.id)")
            } else {
                print("⚠️ Échec du fetch, utilisateur factice utilisé")
                self.isLoggedIn = false
            }
        }
        self.isLoadingUser = false
    }
}

extension User {
    func copy() -> User {
        return User(id: self.id,
                    nameUser: self.nameUser,
                    email: self.email,
                    password: self.password,
                    cycles: self.cycles
                )
    }
}
