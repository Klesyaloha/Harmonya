//
//  CyclesTestView.swift
//  Harmonya
//
//  Created by Klesya on 7/5/25.
//

import SwiftUI

struct PresentationView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("✨ Les Cycles ✨")
                    .font(.largeTitle.bold())
                    .foregroundColor(.sunset)

                // Roue des cycles
                ZStack {
                    Circle().stroke(Color.lilac, lineWidth: 20)
                    Circle().inset(by: 30).stroke(Color.skyBlue, lineWidth: 20)
                    Circle().inset(by: 60).stroke(Color.olivine, lineWidth: 20)
                }
                .frame(width: 250, height: 250)

                VStack(alignment: .leading, spacing: 15) {
                    Label("Cycle Hormonal 💜", systemImage: "drop.fill")
                        .foregroundColor(.lilac)
                    Label("Cycle Lunaire ☁️", systemImage: "moon.stars.fill")
                        .foregroundColor(.skyBlue)
                    Label("Cycle Saisonnier 🌿", systemImage: "leaf.fill")
                        .foregroundColor(.olivine)
                }
                .font(.title3)
            }
            .padding()
        }
    }
}

struct CalendarView2: View {
    let days = Array(1...30) // Exemple

    var body: some View {
        VStack {
            Text("📅 Mon Calendrier")
                .font(.largeTitle.bold())
                .foregroundColor(.sunset)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 20) {
                ForEach(days, id: \.self) { day in
                    VStack {
                        Text("\(day)")
                            .font(.headline)
                            .foregroundColor(.primary)

                        HStack(spacing: 4) {
                            Circle().fill(Color.lilac).frame(width: 8, height: 8)
                            Circle().fill(Color.skyBlue).frame(width: 8, height: 8)
                            Circle().fill(Color.olivine).frame(width: 8, height: 8)
                        }
                    }
                    .frame(width: 40, height: 60)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                }
            }
            .padding()
        }
    }
}

struct JournalView2: View {
    @State private var texte = ""
    @State private var humeur: Double = 3

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("📖 Mon Journal")
                    .font(.largeTitle.bold())
                    .foregroundColor(.sunset)

                // Cycles du jour
                HStack(spacing: 20) {
                    Label("Hormonal", systemImage: "drop.fill").foregroundColor(.lilac)
                    Label("Lunaire", systemImage: "moon.stars.fill").foregroundColor(.skyBlue)
                    Label("Saisonnier", systemImage: "leaf.fill").foregroundColor(.olivine)
                }
                .font(.subheadline)

                // Slider humeur
                VStack(alignment: .leading) {
                    Text("😌 Humeur du jour")
                    Slider(value: $humeur, in: 1...5, step: 1)
                        .accentColor(.sunset)
                }

                // Zone texte
                TextEditor(text: $texte)
                    .frame(height: 200)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.8)))
                    .shadow(radius: 2)

                Button(action: {
                    // Sauvegarde future
                }) {
                    Text("🌸 Sauvegarder mon ressenti")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.sunset)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
            }
            .padding()
        }
        .background(LinearGradient(colors: [.skyBlue.opacity(0.2), .lilac.opacity(0.2)],
                                   startPoint: .top, endPoint: .bottom))
    }
}

struct CyclePhase {
    let name: String
    let symbol: String
}

struct CyclesView: View {
    enum Cycle: String, CaseIterable {
        case lunaire, saisonnier, feminin, masculin
        
        var phases: [CyclePhase] {
            switch self {
            case .lunaire:
                return [
                    CyclePhase(name: "Nouvelle lune", symbol: "🌑"),
                    CyclePhase(name: "Croissant croissant", symbol: "🌒"),
                    CyclePhase(name: "Premier quartier", symbol: "🌓"),
                    CyclePhase(name: "Gibbeuse croissante", symbol: "🌔"),
                    CyclePhase(name: "Pleine lune", symbol: "🌕"),
                    CyclePhase(name: "Gibbeuse décroissante", symbol: "🌖"),
                    CyclePhase(name: "Dernier quartier", symbol: "🌗"),
                    CyclePhase(name: "Croissant décroissant", symbol: "🌘")
                ]
            case .saisonnier:
                return [
                    CyclePhase(name: "Printemps", symbol: "🌱"),
                    CyclePhase(name: "Été", symbol: "☀️"),
                    CyclePhase(name: "Automne", symbol: "🍂"),
                    CyclePhase(name: "Hiver", symbol: "❄️")
                ]
            case .feminin:
                return [
                    CyclePhase(name: "Menstruation", symbol: "🩸"),
                    CyclePhase(name: "Folliculaire", symbol: "🌸"),
                    CyclePhase(name: "Ovulation", symbol: "🌺"),
                    CyclePhase(name: "Lutéale", symbol: "🌿")
                ]
            case .masculin:
                return [
                    CyclePhase(name: "Phase basse", symbol: "😴"),
                    CyclePhase(name: "Phase montée", symbol: "💪"),
                    CyclePhase(name: "Phase haute", symbol: "🔥"),
                    CyclePhase(name: "Phase descendante", symbol: "🛌")
                ]
            }
        }
    }
    
    @State private var selectedCycle: Cycle? = nil
    
    let cycleColors: [Cycle: Color] = [
        .lunaire: .skyBlue,
        .saisonnier: .sunset,
        .feminin: .lilac,
        .masculin: .olivine
    ]
    
    var body: some View {
        ZStack {
            // Anneaux imbriqués
            ForEach(Array(Cycle.allCases.enumerated()), id: \.element) { index, cycle in
                let spacing: CGFloat = 35 // espacement entre les anneaux
                let baseSize: CGFloat = 300
                let lineWidth: CGFloat = 30
                
                Circle()
                    .strokeBorder(
                        (selectedCycle == nil || selectedCycle == cycle) ?
                        cycleColors[cycle]! : Color.gray.opacity(0.3),
                        lineWidth: lineWidth
                    )
                    .frame(
                        width: baseSize - CGFloat(index) * (lineWidth + spacing),
                        height: baseSize - CGFloat(index) * (lineWidth + spacing)
                    )
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedCycle = (selectedCycle == cycle ? nil : cycle)
                        }
                    }
            }
            
            // Boutons pour phases du cycle sélectionné
            if let cycle = selectedCycle {
                let phases = cycle.phases
                let radius: CGFloat = 160
                ForEach(Array(phases.enumerated()), id: \.offset) { i, phase in
                    let angle = Double(i) / Double(phases.count) * 360.0
                    
                    Button(action: {
                        print("Phase: \(phase.name)")
                    }) {
                        Text(phase.symbol)
                            .font(.title2)
                            .frame(width: 50, height: 50)
                            .background(cycleColors[cycle]!.opacity(0.8))
                            .clipShape(Circle())
                            .foregroundColor(.white)
                            .shadow(radius: 3)
                    }
                    .position(
                        x: 150 + radius * cos(angle * .pi / 180),
                        y: 150 + radius * sin(angle * .pi / 180)
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .frame(width: 300, height: 300)
    }
}

#Preview {
    CyclesView()
}

#Preview {
    PresentationView()
}

#Preview {
    CalendarView2()
}

#Preview {
    JournalView2()
}
