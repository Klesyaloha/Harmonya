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
    var password: String
    var cycles : [Cycle]
    var genre: Genre
    
    init() {
        self.nameUser = "Klesya"
        self.email = "klesya@test.fr"
        self.password = "test"
        self.cycles = []
        self.genre = .female
    }
    
    init(id: UUID = UUID(), nameUser: String, email: String, password: String, cycles: [Cycle], genre: Genre) {
        self.id = id
        self.nameUser = nameUser
        self.email = email
        self.password = password
        self.cycles = cycles
        self.genre = genre
    }
    
    func addCycle(_ newCycle: Cycle) {
        cycles.append(newCycle)
    }

    func deleteCycle(_ cycle: Cycle) {
        if let index = cycles.firstIndex(of: cycle) {
            cycles.remove(at: index)
        }
    }
}
