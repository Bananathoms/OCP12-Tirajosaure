//
//  Team.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import Foundation

struct Team: Identifiable {
    var id = UUID()
    var name: String
    var members: [Member] = []
}


