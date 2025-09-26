//
//  User.swift
//  Harmonya
//
//  Created by Klesya on 6/25/25.
//

import Foundation

class User : Codable, ObservableObject, @unchecked Sendable {
    var id = UUID()
    var nameUser: String
    var email: String
    var password: String?
    var cycles : [String]
    
    init() {
        self.nameUser = "Klesya"
        self.email = "klesya@test.fr"
        self.password = "test"
        self.cycles = []
    }
    
    init(id: UUID = UUID(), nameUser: String, email: String, password: String? = nil, cycles: [String]) {
        self.id = id
        self.nameUser = nameUser
        self.email = email
        self.password = password
        self.cycles = cycles
    }
    
    func addCycle(_ newCycle: String) {
        cycles.append(newCycle)
    }

    func deleteCycle(_ cycle: String) {
        if let index = cycles.firstIndex(of: cycle) {
            cycles.remove(at: index)
        }
    }
}
