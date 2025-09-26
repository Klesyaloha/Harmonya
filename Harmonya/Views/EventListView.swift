//
//  EventListView.swift
//  HarmonyaCyrcleCycle
//
//  Created by Klesya on 5/13/25.
//

import SwiftUI

struct EventListView: View {
    @StateObject var userViewModel = UserViewModel()
    var date: Date
    var events: [Event]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if events.isEmpty {
                Text("Aucun événement 💤")
                    .foregroundColor(.gray)
            } else {
                Text("Événements")
                    .font(.headline)
                
                ForEach(events.sorted(by: { $0.title < $1.title })) { event in
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(event.symbol) \(event.title)")
                            .fontWeight(.medium)
                        if !event.description.isEmpty {
                            Text(event.description)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}



#Preview {
    EventListView(date: Date(), events: [Event(userId: UUID(), title: "Test", date: Date(), description: "Test", symbol: "T", color: .red)])
}
