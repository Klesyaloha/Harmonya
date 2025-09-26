//
//  DashboardView.swift
//  Harmonya
//
//  Created by Klesya on 9/23/25.
//

import SwiftUI

struct DashboardView: View {
    enum ViewSelection: String, CaseIterable {
        case journal = "Journal"
        case routines = "Routines"
    }
    
    @State private var selectedView: ViewSelection = .journal
    
    var body: some View {
        NavigationView {
            VStack {
                // Picker Segmented
                Picker("Select View", selection: $selectedView) {
                    ForEach(ViewSelection.allCases, id: \.self) { view in
                        Text(view.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(Color.lilac.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Content
                if selectedView == .journal {
                    JournalView()
                } else {
                    RoutineView()
                }
                
                Spacer()
            }
            .navigationTitle("Dashboard")
        }
    }
}

#Preview {
    DashboardView()
}
