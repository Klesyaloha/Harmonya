//
//  ProfilView.swift
//  Harmonya
//
//  Created by Klesya on 7/1/25.
//

import SwiftUI

struct ProfilView: View {
    @StateObject var calendarManager : CalendarManager
    @StateObject var userViewModel : UserViewModel
    
    var body: some View {
        VStack {
            VStack {
                TextField("Prénom", text: $userViewModel.currentUser.nameUser)
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
                    .frame(height: 50)
                
                TextField("Email", text: $userViewModel.currentUser.email)
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
                    .frame(height: 50)
                
                SecureField("Mot de passe", text: $userViewModel.currentUser.password)
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
                    .frame(height: 50)
                
                DisclosureGroup("Cycles") {
                    ForEach(userViewModel.currentUser.cycles) { cycle in
                        Text(cycle.name)
                    }
                }
                .foregroundStyle(.black)
                .padding(.leading, 58.223)
                    .background {
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: 311, height: 69)
                          .background(Color(red: 0.92, green: 0.8, blue: 0.55).opacity(0.45))
                          .cornerRadius(22)
                          .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
                    }
                
                Picker("Genre", selection: $userViewModel.currentUser.genre) {
                    ForEach(Genre.allCases) { gender in
                        Text(gender.label)
                            .tag(gender)
                    }
                }
                .pickerStyle(SegmentedPickerStyle()) // Style segmenté horizontal
                .padding()
            }
            .padding()
            
            Button(action: {
                calendarManager.removeEvents()
                userViewModel.currentUser.cycles.removeAll()
            }, label: {
                Text("Réinitialiser le calendrier")
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            })
        }
    }
}

#Preview {
    ProfilView(calendarManager: CalendarManager(), userViewModel: UserViewModel())
}
