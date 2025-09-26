//
//  ProfilView.swift
//  Harmonya
//
//  Created by Klesya on 7/1/25.
//

import SwiftUI

struct ProfilView: View {
    @EnvironmentObject var calendarManager : CalendarManager
    @EnvironmentObject var userViewModel : UserViewModel

    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmNewPassword: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    Text("Profil Utilisateur")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.skyBlue)
                        .padding(.top, 20)
                    
                    // Champs modifiables
                    profileField("Prénom", text: $userViewModel.currentUser.nameUser)
                    profileField("Email", text: $userViewModel.currentUser.email)
                    
                    // Section Mot de passe
                    SecureField("Mot de passe actuel", text: $oldPassword)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(.ultraThinMaterial))
                        .padding(.horizontal)
                    SecureField("Nouveau mot de passe", text: $newPassword)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(.ultraThinMaterial))
                        .padding(.horizontal)
                    SecureField("Confirmer le nouveau mot de passe", text: $confirmNewPassword)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(.ultraThinMaterial))
                        .padding(.horizontal)
                    
                    DisclosureGroup("Cycles") {
                        ForEach(userViewModel.currentUser.cycles, id: \.self) { cycle in
                            Text(cycle)
                                .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
                    )
                    
                    // Bouton pour sauvegarder les modifications
                    Button(action: { Task { await saveProfileChanges() } }) {
                        Text("💾 Sauvegarder")
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.skyBlue)
                            .cornerRadius(15)
                            .shadow(color: .blue.opacity(0.4), radius: 5, x: 0, y: 3)
                    }
                    
                    Button(action: { resetCalendar() }) {
                        Text("Réinitialiser le calendrier")
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(15)
                            .shadow(color: .red.opacity(0.4), radius: 5, x: 0, y: 3)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { userViewModel.logout() }) {
                            Image(systemName: "power")
                                .foregroundStyle(.red)
                                .padding(.trailing, 10)
                        }
                    }
                }
            }
            .alert(userViewModel.alertUpdateMessage, isPresented: $userViewModel.showUpdateAlert) {
                Button("OK", role: .cancel) {}
            }
            .onAppear {
                Task {
                    await userViewModel.loadCurrentUserIfLoggedIn()
                }
            }
        }
    }
    
    // MARK: - Composants réutilisables
    @ViewBuilder
    private func profileField(_ title: String, text: Binding<String>) -> some View {
        TextField(title, text: text)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
            )
            .padding(.horizontal)
    }
    
    // MARK: - Réinitialiser le calendrier
    func resetCalendar() {
        Task {
            let userId = userViewModel.currentUser.id
            await calendarManager.deleteEventsFromServer(for: userId)
            calendarManager.removeEvents()
            userViewModel.currentUser.cycles.removeAll()
            await userViewModel.updateUserCycles()
        }
    }
    
    // MARK: - Sauvegarder les modifications et changer le mot de passe
    private func saveProfileChanges() async {
        // 1️⃣ Mettre à jour nom et email
        await userViewModel.updateUserData()
        
        // 2️⃣ Changer le mot de passe si nécessaire
        if !oldPassword.isEmpty || !newPassword.isEmpty || !confirmNewPassword.isEmpty {
            guard !oldPassword.isEmpty else {
                userViewModel.alertUpdateMessage = "Veuillez entrer votre mot de passe actuel."
                userViewModel.showUpdateAlert = true
                return
            }
            guard !newPassword.isEmpty else {
                userViewModel.alertUpdateMessage = "Veuillez entrer un nouveau mot de passe."
                userViewModel.showUpdateAlert = true
                return
            }
            guard newPassword == confirmNewPassword else {
                userViewModel.alertUpdateMessage = "Le nouveau mot de passe ne correspond pas à la confirmation."
                userViewModel.showUpdateAlert = true
                return
            }
            
            await userViewModel.changePassword(oldPassword: oldPassword, newPassword: newPassword)
            
            // Réinitialiser les champs après succès
            oldPassword = ""
            newPassword = ""
            confirmNewPassword = ""
        }
    }
}

#Preview {
    ProfilView()
        .environmentObject(UserViewModel())
        .environmentObject(CalendarManager())
}

