//
//  Paragraph.swift
//  Harmonya
//
//  Created by Klesya on 7/1/25.
//

import Foundation
import SwiftUI

struct Paragraph : Codable, Identifiable , Equatable, Hashable {
    var id: UUID = UUID()
    let title : String
    let text : String
}
