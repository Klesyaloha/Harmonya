//
//  TabBar.swift
//  HarmonyaCyrcleCycle
//
//  Created by Klesya on 5/14/25.
//

import SwiftUI

enum Tab {
    case cycles
    case calendar
    case dashboard
    case profil
}

struct TabBar: View {
    @State private var selectedTab: Tab = .calendar
    @EnvironmentObject var calendarManager: CalendarManager
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var cycleViewModel: CyclesViewModel2

    var body: some View {
        TabView(selection: $selectedTab) {
            CyclesMenuView()
                .tabItem { Label("Cycles", systemImage: "arrow.circlepath") }
                .tag(Tab.cycles)
                
            CalendarView()
                .tabItem { Label("Calendrier", systemImage: "calendar") }
                .tag(Tab.calendar)
            
            DashboardView()
                .tabItem { Label("Dashboard", systemImage: "heart.text.clipboard") }
                .tag(Tab.dashboard)
            
            ProfilView()
                .tabItem { Label("Profil", systemImage: "slider.vertical.3") }
                .tag(Tab.profil)
        }
    }
}

#Preview {
    let calendarManager = CalendarManager()
    let userViewModel = UserViewModel()
    let cycleViewModel = CyclesViewModel2()

    TabBar()
        .environmentObject(calendarManager)
        .environmentObject(userViewModel)
        .environmentObject(cycleViewModel)
}


import SwiftUI

struct GlassTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // 🖼️ Contenu principal selon l’onglet
            TabView(selection: $selectedTab) {
                CyclesMenuView()
                    .tag(0)
                CalendarView()
                    .tag(1)
                ProfilView()
                    .tag(2)
            }
            
            // 🌙 Barre flottante en bas (Glassmorphism)
            VStack {
                Spacer()
                HStack(spacing: 40) {
                    GlassTabButton(icon: "moon.stars.fill", tab: 0, selectedTab: $selectedTab)
                    GlassTabButton(icon: "calendar", tab: 1, selectedTab: $selectedTab)
                    GlassTabButton(icon: "book.closed.fill", tab: 2, selectedTab: $selectedTab)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial) // 💎 verre dépoli
                .clipShape(Capsule())
                .shadow(radius: 8)
                .padding(.bottom, 20)
            }
        }
    }
}

// 🔘 Bouton glassmorphism pour chaque onglet
struct GlassTabButton: View {
    let icon: String
    let tab: Int
    @Binding var selectedTab: Int
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                selectedTab = tab
            }
        } label: {
            Image(systemName: icon)
                .font(.title2.bold())
                .foregroundColor(selectedTab == tab ? .sunset : .white)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .shadow(radius: 3)
                )
        }
    }
}

#Preview {
    let calendarManager = CalendarManager()
    let userViewModel = UserViewModel()
    let cycleViewModel = CyclesViewModel()
    GlassTabView()
        .environmentObject(calendarManager)
        .environmentObject(userViewModel)
        .environmentObject(cycleViewModel)
}
