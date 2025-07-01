//
//  CyclesViewModel2.swift
//  Harmonya
//
//  Created by Klesya on 7/1/25.
//

import Foundation
import SwiftUI

@MainActor
class CyclesViewModel2: ObservableObject {
    @Published var cycles: [Cycle] = []

    func fetchCycles() async {
        guard let url = URL(string: "http://localhost:8080/cycles") else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoded = try decoder.decode([Cycle].self, from: data)
            self.cycles = decoded
        } catch {
            print("❌ Failed to fetch cycles:", error)
        }
    }
}
