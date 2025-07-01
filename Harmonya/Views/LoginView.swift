//
//  ConnexionView.swift
//  CalendarApp
//
//  Created by Klesya on 5/16/25.
//

import SwiftUI

struct ConnexionView: View {
    @EnvironmentObject var viewModel : UserViewModel
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 150)
            
            Image("harmonyaLogo")
                .padding()
            
            Spacer()
                .frame(height: 50)
            
            TextField(text: $viewModel.currentUser.email, label: {
                Text("Adresse Mail")
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
            
            Spacer()
                .frame(height: 70.0)
            
            SecureField(text: $viewModel.currentUser.password, label: {
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
            
            Spacer()
                .frame(height: 70)
            
            Button(action: {
                
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
            
            Spacer()
        }
    }
}

#Preview {
    ConnexionView()
        .environmentObject(UserViewModel())
}
