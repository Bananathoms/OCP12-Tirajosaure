//
//  Event.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import Foundation
import ParseSwift

struct Event: ParseObject, Identifiable, Codable {
    var originalData: Data?

    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var title: String
    var user: Pointer<User>
    var equitableDistribution: Bool
    var teams: [String]
    var members: [String]

    // Initializer for creating a new Event
    init(title: String, user: Pointer<User>, equitableDistribution: Bool, teams: [String], members: [String]) {
        self.title = title
        self.user = user
        self.equitableDistribution = equitableDistribution
        self.teams = teams
        self.members = members
    }

    // Initializer for updating an existing Event
    init(objectId: String?, title: String, user: Pointer<User>, equitableDistribution: Bool, teams: [String], members: [String]) {
        self.objectId = objectId
        self.title = title
        self.user = user
        self.equitableDistribution = equitableDistribution
        self.teams = teams
        self.members = members
    }

    // Default initializer required by ParseObject
    init() {
        self.title = ""
        self.user = Pointer<User>(objectId: "")
        self.equitableDistribution = true
        self.teams = []
        self.members = []
    }
}
