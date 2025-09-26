//
//  ConnexionView.swift
//  CalendarApp
//
//  Created by Klesya on 5/16/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel : UserViewModel
    @State private var hasTriedLogin = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                    .frame(height: 150)
                
                Image("harmonyaLogo")
                    .padding()
                
                Spacer()
                    .frame(height: 50)
                
                TextField(text: $viewModel.currentUser.email // 🔹 Tout en minuscule
                , label: {
                    Text("Adresse Mail")
                })
                .textInputAutocapitalization(.never)
                .padding(.leading, 58.223)
                .background {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 311, height: 69)
                        .background(Color(red: 0.92, green: 0.8, blue: 0.55).opacity(0.45))
                        .cornerRadius(22)
                        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
                }
                
                Spacer()
                    .frame(height: 70.0)
                
                SecureField(text: Binding(
                    get: { viewModel.currentUser.password ?? "" },
                    set: { viewModel.currentUser.password = $0 }), label: {
                        Text("Mot de passe")
                    })
                .padding(.leading, 58.223)
                .background {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 311, height: 69)
                        .background(Color(red: 0.92, green: 0.8, blue: 0.55).opacity(0.45))
                        .cornerRadius(22)
                        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
                }
                
                HStack {
                    Text("Nouveau ?")
                    
                    NavigationLink(destination: RegisterView()) {
                        Text(" Inscrivez-vous ici")
                            .foregroundColor(.skyBlue)
                            .bold()
                    }
                }
                .padding(.top, 25)
                
                Spacer()
                    .frame(height: 70)
                
                Button(action: {
                    hasTriedLogin = true
                    Task {
                        await viewModel.login()
                    }
                }, label: {
                    Text("Se connecter")
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .background{
                            Rectangle()
                                .foregroundColor(.skyBlue)
                                .cornerRadius(12)
                        }
                })
                
                if hasTriedLogin {
                    // Gestion erreur d'authentification (email, mdp, serveur)
                    if !isValidEmail(viewModel.currentUser.email) && viewModel.currentUser.password == "" {
                        Text("Email et mot de passe invalides")
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                    } else if !isValidEmail(viewModel.currentUser.email) {
                        Text("Email invalide")
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                    } else if viewModel.currentUser.password == "" {
                        Text("Mot de passe requis")
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                    } else if let error = viewModel.loginError {
                        Text(error)
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    // Verifie le format de l'email
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

#Preview {
    LoginView()
        .environmentObject(UserViewModel())
}
