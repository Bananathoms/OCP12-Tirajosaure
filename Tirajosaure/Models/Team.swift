//
//  Team.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import Foundation
import ParseSwift

struct Team: ParseObject {
    var originalData: Data?

    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var name: String
    var event: Pointer<Event>

    init(name: String, event: Pointer<Event>) {
        self.name = name
        self.event = event
    }

    init() {
        self.name = ""
        self.event = Pointer<Event>(objectId: "")
    }
}
