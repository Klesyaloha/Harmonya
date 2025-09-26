//
//  HarmonyaApp.swift
//  Harmonya
//
//  Created by Klesya on 3/24/25.
//

import SwiftUI
import SwiftData

@main
struct HarmonyaApp: App {
    @StateObject var userViewModel = UserViewModel()
    @StateObject var calendarManager = CalendarManager()
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(userViewModel)
                .environmentObject(calendarManager)
        }
    }
}

struct RootView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var calendarManager: CalendarManager
    
    var body: some View {
        Group {
            if userViewModel.isLoading {
                ProgressView("Chargement…")
            } else if userViewModel.isLoggedIn {
                TabBar()
            } else {
                LoginView()
            }
        }
        .task {
            await userViewModel.loadCurrentUserIfLoggedIn()
        }
    }
}
