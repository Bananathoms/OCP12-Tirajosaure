//
//  Member.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import Foundation
import ParseSwift

struct Member: ParseObject {
    var originalData: Data?

    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var name: String
    var event: Pointer<Event>
    var team: Pointer<Team>?

    init(name: String, event: Pointer<Event>, team: Pointer<Team>? = nil) {
        self.name = name
        self.event = event
        self.team = team
    }

    init() {
        self.name = ""
        self.event = Pointer<Event>(objectId: "")
        self.team = nil
    }
}
