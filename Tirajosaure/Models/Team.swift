//
//  Team.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import Foundation

struct Team: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var members: [Member] = []

    static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.members == rhs.members
    }
}
