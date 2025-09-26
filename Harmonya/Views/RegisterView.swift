//
//  RegisterView.swift
//  Harmonya
//
//  Created by Klesya on 7/3/25.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var userViewModel : UserViewModel
    @State private var selectedCycles: [String] = []
    
    @Environment(\.dismiss) var dismiss

    var cyclesViewModel = CyclesViewModel()
    var body: some View {
        VStack {
            VStack(spacing: 5) {
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
                    .frame(height: 50)
                
                SecureField(text: Binding(
                    get: { userViewModel.currentUser.password ?? "" },
                    set: { userViewModel.currentUser.password = $0 }), label: { Text("Password")
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
                    .frame(height: 50)
                
//                ForEach(cyclesViewModel.cycles) { cycle in
//                    HStack {
//                        Text(cycle.name)
//                            .padding()
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .background(selectedCycles.contains(cycle.name) ? Color.olivine.opacity(0.2) : Color.gray.opacity(0.1))
//                            .cornerRadius(10)
//                    }
//                    .onTapGesture {
//                        if selectedCycles.contains(cycle.name) {
//                            selectedCycles.remove(at: selectedCycles.firstIndex(of: cycle.name)!)
//                        } else {
//                            selectedCycles.append(cycle.name)
//                        }
//                    }
//                }.padding(.horizontal)
//                
//                Text("✅ Sélectionnés : \(selectedCycles.joined(separator: ", "))")
//                    .padding(.top)
            }
            .padding()
            
            Button(action: {
                userViewModel.currentUser.cycles = selectedCycles
                Task {
                    await userViewModel.register()
                    dismiss()
                }
            }, label: {
                Text("S'enregistrer")
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.lilac)
                    .cornerRadius(10)
            })
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(UserViewModel())
}
