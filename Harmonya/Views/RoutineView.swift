//
//  RoutineView.swift
//  Harmonya
//
//  Created by Klesya on 9/25/25.
//
import SwiftUI

struct RoutineView: View {
    @StateObject var routineViewModel = RoutineViewModel()

    @State private var newRoutine: Routine = Routine(
        userId: UUID(),
        title: "",
        symbol: .bolt,
        content: [],
        color: .accentColor,
        frequency: .daily,
        weekday: nil,
        weekOfMonth: nil
    )
    @State private var newContent: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var selectedRoutine: Routine? = nil
    @State private var checkedActions: [Bool] = []
    
    @State private var addRoutineIsPresented: Bool = false
    
    private let weekdaySymbols: [String] = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        return dateFormatter.weekdaySymbols
    }()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {

                    // MARK: - Carte d'ajout de routine
                    if addRoutineIsPresented {
                        addRoutineCard
                    }

                    // MARK: - Liste des routines existantes
                    routinesGrid
                }
                .padding(.bottom)
            }
            .toolbar {
                Button(action: {
                    addRoutineIsPresented.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .foregroundStyle(addRoutineIsPresented ? .white : newRoutine.color)
                        .frame(width: 40, height: 40)
                        .background(addRoutineIsPresented ? newRoutine.color : .gray.opacity(0.08))
                        .cornerRadius(10)
                })
            }
            .navigationBarTitleDisplayMode(.inline)
            .overlay(
                Group {
                    if let routine = selectedRoutine {
                        routineDetailOverlay(routine: routine)
                    }
                }
            )
        }
        .onAppear {
            routineViewModel.fetchRoutines()
        }
    }

    // MARK: - Sous-vue pour l'ajout
    private var addRoutineCard: some View {
        VStack(spacing: 16) {
            TextField("Titre de la routine", text: $newRoutine.title)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            ForEach(newRoutine.content, id: \.self) { content in
                HStack {
                    Image(systemName: "circle.fill")
                    Text(content)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            TextField("Ajouter une action", text: $newContent)
                .focused($isTextFieldFocused)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .onSubmit {
                    newRoutine.content.append(newContent)
                    newContent = ""
                    isTextFieldFocused = true
                }

            symbolPicker
            ColorPicker("Couleur", selection: $newRoutine.color)
            frequencyPicker

            if newRoutine.frequency == .weekly {
                weeklyPicker
            }

            if newRoutine.frequency == .monthly {
                monthlyPicker
            }

            Button(action: {
                Task {
                    await routineViewModel.addRoutine(routine: newRoutine)
                    
                    // Reset
                    newRoutine = Routine(
                        userId: UUID(),
                        title: "",
                        symbol: .bolt,
                        content: [],
                        color: .accentColor,
                        frequency: .daily,
                        weekday: nil,
                        weekOfMonth: nil
                    )
                    newContent = ""
                }
            }) {
                Text("Ajouter la routine")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(newRoutine.color)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 3)
        )
        .padding(.horizontal)
    }

    // MARK: - Picker symboles
    private var symbolPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(RoutineSymbol.allCases, id: \.self) { symbol in
                    Image(systemName: symbol.rawValue)
                        .font(.title2)
                        .padding(8)
                        .background(newRoutine.symbol == symbol ? newRoutine.color.opacity(0.3) : Color.clear)
                        .cornerRadius(8)
                        .onTapGesture { newRoutine.symbol = symbol }
                }
            }
        }
    }

    // MARK: - Picker fréquence
    private var frequencyPicker: some View {
        Picker("Frequency", selection: $newRoutine.frequency) {
            ForEach(RoutineFrequency.allCases, id: \.self) { freq in
                Text(freq.rawValue.capitalized).tag(freq)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }

    // MARK: - Picker jour si weekly
    private var weeklyPicker: some View {
        Picker("Jour de la semaine", selection: Binding(
            get: { newRoutine.weekday ?? 1 },
            set: { newRoutine.weekday = $0 }
        )) {
            ForEach(1..<8) { i in
                Text(weekdaySymbols[i-1].capitalized).tag(i)
            }
        }
        .pickerStyle(.menu)
    }

    // MARK: - Picker semaine et jour si monthly
    private var monthlyPicker: some View {
        VStack {
            Stepper("Semaine du mois: \(newRoutine.weekOfMonth ?? 1)",
                    value: Binding(
                        get: { newRoutine.weekOfMonth ?? 1 },
                        set: { newRoutine.weekOfMonth = $0 }
                    ),
                    in: 1...4)
            Picker("Jour de la semaine", selection: Binding(
                get: { newRoutine.weekday ?? 1 },
                set: { newRoutine.weekday = $0 }
            )) {
                ForEach(1..<8) { i in
                    Text(weekdaySymbols[i-1].capitalized).tag(i)
                }
            }
            .pickerStyle(.menu)
        }
    }

    // MARK: - Grid des routines existantes
    private var routinesGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 16)], spacing: 16) {
            ForEach(routineViewModel.routines) { routine in
                VStack(spacing: 8) {
                    Image(systemName: routine.symbol.rawValue)
                        .font(.largeTitle)
                        .foregroundColor(routine.color)
                    Text(routine.title)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    Text("\(routine.frequency.rawValue.capitalized)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("\(routine.content.count) Actions")
                        .font(.caption2)
                        .padding(4)
                        .background(routine.color.opacity(0.3))
                        .cornerRadius(6)
                }
                .padding()
                .frame(width: 170, height: 170)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white) // ou transparent
                            .shadow(color: routine.color.opacity(0.5), radius: 4, x: 0, y: 2)
                        
                        RoundedRectangle(cornerRadius: 15)
                            .fill(routine.color.opacity(0.05))
                    }
                )
                .onTapGesture {
                    selectedRoutine = routine
                    checkedActions = Array(repeating: false, count: routine.content.count)
                }
            }
        }
        .padding()
    }
    
    private func routineDetailOverlay(routine: Routine) -> some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    selectedRoutine = nil
                }
            
            VStack(spacing: 16) {
                // Header
                HStack(spacing: 12) {
                    Image(systemName: routine.symbol.rawValue)
                        .font(.largeTitle)
                        .foregroundColor(routine.color)
                    VStack {
                        Text(routine.title)
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if routine.frequency == .daily {
                            Text("Tous les jours")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                        } else if routine.frequency == .weekly {
                            Text("Tous les \(weekdaySymbols[(routine.weekday ?? 1) - 1])")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else if routine.frequency == .monthly {
                            Text("Tous les \(routine.weekOfMonth ?? 1)e \(weekdaySymbols[(routine.weekday ?? 1) - 1]) du mois")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    
                    Spacer()
                }
                .padding()
                
                // Actions
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(routine.content.indices, id: \.self) { index in
                        HStack {
                            Button(action: {
                                checkedActions[index].toggle()
                            }) {
                                Image(systemName: checkedActions[index] ? "checkmark.square.fill" : "square")
                                    .foregroundColor(checkedActions[index] ? routine.color : .gray)
                            }
                            Text(routine.content[index])
                                .foregroundColor(.primary)
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    Task {
                        await routineViewModel.removeRoutine(routineId: routine.id)
                        selectedRoutine = nil
                    }
                }, label: {
                    Text("Supprimer la routine")
                        .foregroundStyle(.red)
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                })
                
                // Bouton décocher tout
                Button(action: {
                    checkedActions = Array(repeating: false, count: routine.content.count)
                }) {
                    Text("Décocher tout")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(routine.color)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 8)
            )
            .padding(.horizontal, 24)
        }
    }

}

#Preview {
    RoutineView()
}
