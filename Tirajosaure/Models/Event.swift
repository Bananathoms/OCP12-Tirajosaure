//
//  Event.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 23/06/2024.
//

import Foundation
import ParseSwift

struct Event: ParseObject {
    var originalData: Data?

    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var title: String
    var equitableDistribution: Bool
    var user: Pointer<User>

    init(title: String, user: Pointer<User>, equitableDistribution: Bool = true) {
        self.title = title
        self.user = user
        self.equitableDistribution = equitableDistribution
    }

    init() {
        self.title = ""
        self.user = Pointer<User>(objectId: "")
        self.equitableDistribution = true
    }
}
