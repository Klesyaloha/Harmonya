//
//  EventListView.swift
//  HarmonyaCyrcleCycle
//
//  Created by Klesya on 5/13/25.
//

import SwiftUI

struct EventListView: View {
    var date: Date
    var events: [Event]

    var body: some View {
        VStack(alignment: .leading) {
            if events.isEmpty {
                Text("Aucun événement 💤")
                    .foregroundColor(.gray)
            } else {
                HStack {
                    VStack {
                        Text("Événements")
                            .font(.headline)
                        ForEach(events) { event in
                            VStack(alignment: .leading) {
                                Text("\(event.symbol) \(event.title)")
                                    .fontWeight(.medium)
                                if !event.description.isEmpty {
                                    Text(event.description)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    Spacer()
                }
                
            }
        }
        .padding()
    }
}


#Preview {
    EventListView(date: Date(), events: [Event(title: "Test", date: Date(), description: "Test", symbol: "T", color: .red)])
}
