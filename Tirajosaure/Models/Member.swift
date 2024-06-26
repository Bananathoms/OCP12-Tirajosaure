//
//  Member.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import Foundation

struct Member: Identifiable, Equatable {
    var id = UUID()
    var name: String

    static func == (lhs: Member, rhs: Member) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
