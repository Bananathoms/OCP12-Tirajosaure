//
//  Event.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import Foundation

struct Event: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var members: [Member]
    var teams: [Team]
    var equitableDistribution: Bool

    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.members == rhs.members &&
               lhs.teams == rhs.teams &&
               lhs.equitableDistribution == rhs.equitableDistribution
    }
}

