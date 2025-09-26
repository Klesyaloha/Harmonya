//
//  Mood.swift
//  Harmonya
//
//  Created by Klesya on 9/23/25.
//

import Foundation

enum MoodType: String, Codable, CaseIterable {
    case happy = "😊"
    case tired = "😴"
    case stressed = "😰"
    case calm = "😌"
    case sad = "😢"
    case angry = "😡"
}

struct Mood: Identifiable, Codable {
    var id: UUID = UUID()
    var userId : UUID
    var date: Date
    var energyLevel: Int
    var mood: MoodType
}
