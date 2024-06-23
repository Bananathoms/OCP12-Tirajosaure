//
//  Event.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import Foundation

struct Event: Identifiable {
    let id: UUID = UUID()
    var title: String
    var members: [Member]
    var teams: [Team] = [] // Ajouter cette ligne
    var equitableDistribution: Bool = true // Ajouter cette ligne
}
