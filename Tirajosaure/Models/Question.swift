//
//  Question.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 15/06/2024.
//

import Foundation
import ParseSwift

/// A struct representing a question in the Parse server.
struct Question: ParseObject, Identifiable, Codable {
    var originalData: Data?
    
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    
    var title: String
    var options: [String]
    var user: Pointer<User>

    init() {
        self.title = ""
        self.options = []
        self.user = Pointer<User>(objectId: "")
    }

    init(title: String, options: [String], user: Pointer<User>) {
        self.title = title
        self.options = options
        self.user = user
    }

    init(objectId: String? = nil, createdAt: Date? = nil, updatedAt: Date? = nil, ACL: ParseACL? = nil, id: UUID = UUID(), title: String, options: [String], user: Pointer<User>) {
        self.objectId = objectId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.ACL = ACL
        self.title = title
        self.options = options
        self.user = user
    }
}
