//
//  ContenteView.swift
//  Harmonya
//
//  Created by Klesya on 5/4/25.
//

import Foundation
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image("harmonyaLogo")
            Spacer()
            CalendarView()
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
