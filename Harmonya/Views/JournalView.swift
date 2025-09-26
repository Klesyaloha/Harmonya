//
//  JournalView.swift
//  Harmonya
//
//  Created by Klesya on 9/25/25.
//
import SwiftUI

struct JournalView: View {
    @StateObject var journalViewModel = JournalViewModel()
    @StateObject var moodViewModel = MoodViewModel()
    
    @State var newJournal : Journal = Journal(userId: UUID(), date: Date(), content: "", tags: [])
    @State var newTag : String = ""
    @State var addJournalIsPresented : Bool = false
    
    @State var newMood : Mood = Mood(userId: UUID(), date: Date(), energyLevel: 0, mood: .happy)
    @State var addMoodIsPresented : Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                if addMoodIsPresented {
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("Ajouter une émotion")
                            .font(.headline)
                            .foregroundColor(.sunset)
                        
                        Picker("Mood", selection: $newMood.mood) {
                            ForEach(MoodType.allCases, id: \.self) { mood in
                                Text(mood.rawValue)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        
                        VStack {
                            HStack {
                                Text("Niveau d'énergie")
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Text("\(newMood.energyLevel) / 5")
                                
                            }
                            .foregroundColor(.gray)
                            
                            HStack(spacing: 16) {
                                // Barre de progression
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(height: 24)
                                    
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.yellow, .orange, .red]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(width: CGFloat(newMood.energyLevel) / 5 * 200, height: 24)
                                        .animation(.easeInOut, value: newMood.energyLevel)
                                }
                                .frame(width: 200)
                                
                                // Stepper à droite
                                Stepper(value: $newMood.energyLevel, in: 0...5) {
                                    Text("") // Stepper n'a pas de label ici
                                }
                                .labelsHidden()
                            }
                            .cornerRadius(16)
                            .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                        
                        
                        Button(action: {
                            Task {
                                await moodViewModel.addMood(mood: newMood)
                                newMood = Mood(userId: UUID(), date: Date(), energyLevel: 0, mood: .happy)
                            }
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Enregistrer")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.sunset)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.sunset.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                
                // ✅ Zone pour ajouter un Journal
                if addJournalIsPresented {
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("Ajouter une note au journal")
                            .font(.headline)
                            .foregroundColor(.skyBlue)
                        
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $newJournal.content)
                                .padding(10)
                                .frame(height: 140)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                            
                            if newJournal.content.isEmpty {
                                Text("Que ressentez-vous aujourd'hui ?")
                                    .foregroundColor(.gray.opacity(0.6))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                            }
                        }
                        
                        TextField("Ajouter un tag...", text: $newTag)
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .onSubmit {
                                if !newTag.isEmpty {
                                    newJournal.tags.append(newTag)
                                    newTag = ""
                                }
                            }
                        
                        if !newJournal.tags.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(newJournal.tags, id: \.self) { tag in
                                        Text("#\(tag)")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 8)
                                            .background(Color.skyBlue)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        
                        Button(action: {
                            Task {
                                await journalViewModel.addJournal(journal : newJournal)
                                newJournal = Journal(userId: UUID(), date: Date(), content: "", tags: [])
                            }
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Enregistrer")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.skyBlue)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.skyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                
                // ✅ Liste des Journaux
                ScrollView {
                    VStack(spacing: 12) {
                        // Récupérer toutes les dates uniques depuis journals et moods
                        let allDates: [Date] = {
                            let journalDates = journalViewModel.journals.map { Calendar.current.startOfDay(for: $0.date) }
                            let moodDates = moodViewModel.moods.map { Calendar.current.startOfDay(for: $0.date) }
                            let combined = Array(Set(journalDates + moodDates))
                            return combined.sorted(by: >) // tri décroissant
                        }()

                        ForEach(allDates, id: \.self) { date in
                            VStack(alignment: .leading, spacing: 8) {
                                // Date
                                Text(DateFormatter.localizedString(from: date, dateStyle: .full, timeStyle: .none))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                // Moods de cette date
                                ForEach(moodViewModel.moods.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }, id: \.id) { mood in
                                    HStack(spacing: 12) {
                                        // Emoji mood
                                        Text(mood.mood.rawValue)
                                            .font(.largeTitle)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            // Barre de progression
                                            ZStack(alignment: .leading) {
                                                // Fond de la barre
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.gray.opacity(0.3))
                                                    .frame(height: 16)
                                                
                                                // Barre de progression
                                                GeometryReader { geo in
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(
                                                            LinearGradient(
                                                                gradient: Gradient(colors: [.yellow, .orange, .red]),
                                                                startPoint: .leading,
                                                                endPoint: .trailing
                                                            )
                                                        )
                                                        .frame(width: CGFloat(mood.energyLevel) / 5 * geo.size.width, height: 16)
                                                        .animation(.easeInOut, value: mood.energyLevel)
                                                }
                                                .frame(height: 16)
                                            }
                                            
                                            // Niveau d'énergie
                                            Text("Énergie: \(mood.energyLevel)/5")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Button(action: {
                                            Task {
                                                await moodViewModel.removeMood(moodId: mood.id)
                                            }
                                        }, label : {
                                            Image(systemName: "trash")
                                                .foregroundStyle(.red)
                                        })
                                    }
                                    .padding()
                                    .background(Color.sunset.opacity(0.1))
                                    .cornerRadius(12)
                                    .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 2)
                                    
                                }
                                
                                // Journals de cette date
                                ForEach(journalViewModel.journals.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }, id: \.id) { journal in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(journal.content)
                                                .font(.body)
                                                .foregroundColor(.primary)
                                            
                                            if !journal.tags.isEmpty {
                                                HStack {
                                                    ForEach(journal.tags, id: \.self) { tag in
                                                        Text("#\(tag)")
                                                            .font(.caption2)
                                                            .foregroundColor(.white)
                                                            .padding(4)
                                                            .background(Color.olivine)
                                                            .cornerRadius(6)
                                                    }
                                                }
                                            }
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Button(action: {
                                            Task {
                                                await journalViewModel.removeJournal(journalId: journal.id)
                                            }
                                        }, label : {
                                            Image(systemName: "trash")
                                                .foregroundStyle(.red)
                                        })
                                        .padding()
                                    }
                                    .background(Color.skyBlue.opacity(0.1))
                                    .cornerRadius(12)
                                    .shadow(color: .gray.opacity(0.1), radius: 3, x: 0, y: 2)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    HStack(spacing: 2) {
                        Button(action: {
                            addMoodIsPresented.toggle()
                        }) {
                            Image(systemName: "face.smiling.inverse")
                                .foregroundStyle(addMoodIsPresented ? .white : .sunset)
                                .frame(width: 40, height: 40)
                                .background(addMoodIsPresented ? .sunset : .gray.opacity(0.08))
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            addJournalIsPresented.toggle()
                        }) {
                            Image(systemName: "book.fill")
                                .foregroundStyle(addJournalIsPresented ? .white : .skyBlue)
                                .frame(width: 40, height: 40)
                                .background(addJournalIsPresented ? .skyBlue : .gray.opacity(0.08))
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                journalViewModel.fetchJournals()
                moodViewModel.fetchMoods()
            }
        }
    }
}

#Preview {
    JournalView()
}
