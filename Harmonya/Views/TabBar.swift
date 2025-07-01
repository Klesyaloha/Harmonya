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
    case settings
}

struct TabBar: View {
    @State private var selectedTab: Tab = .calendar
    @StateObject private var calendarManager: CalendarManager = CalendarManager()
    @StateObject private var userViewModel: UserViewModel = UserViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CyclesMenuView(calendarManager: calendarManager, userViewModel: userViewModel)
                .tabItem { Label("Cycles", systemImage: "arrow.circlepath")}
                .tag(Tab.cycles)
            
            CalendarView(calendarManager: calendarManager)
                .tabItem { Label("Calendrier", systemImage: "calendar")}
                .tag(Tab.calendar)
            
            ProfilView(calendarManager: calendarManager, userViewModel: userViewModel)
                .tabItem { Label("`Profil", systemImage: "slider.vertical.3")}
                .tag(Tab.settings)
        }
    }
}

#Preview {
    TabBar()
}
