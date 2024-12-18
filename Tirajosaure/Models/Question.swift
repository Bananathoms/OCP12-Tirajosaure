//
//  Question.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 15/06/2024.
//

import Foundation
import ParseSwift

/// A struct representing a question in the Parse server.
struct Question: ParseObject, Identifiable, Equatable {
    var originalData: Data?
    
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var title: String
    var options: [String]
    var user: Pointer<User>

    // Satisfying the Identifiable protocol
    var id: String {
        return objectId ?? UUID().uuidString
    }

    // Initializer for creating a new Question
    init(title: String, options: [String], user: Pointer<User>) {
        self.title = title
        self.options = options
        self.user = user
    }

    // Default initializer required by ParseObject
    init() {
        self.title = ""
        self.options = []
        self.user = Pointer<User>(objectId: "")
    }

    // Custom Equatable implementation
    static func == (lhs: Question, rhs: Question) -> Bool {
        return lhs.objectId == rhs.objectId &&
               lhs.createdAt == rhs.createdAt &&
               lhs.updatedAt == rhs.updatedAt &&
               lhs.title == rhs.title &&
               lhs.options == rhs.options &&
               lhs.user == rhs.user
    }
    
    
    // Custom encode and decode methods to handle date conversion
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(objectId, forKey: .objectId)
        try container.encode(title, forKey: .title)
        try container.encode(options, forKey: .options)
        try container.encode(user, forKey: .user)
        try container.encode(ACL, forKey: .ACL)
        
        if let createdAt = createdAt {
            try container.encode(DateFormatter.iso8601Full.string(from: createdAt), forKey: .createdAt)
        }
        
        if let updatedAt = updatedAt {
            try container.encode(DateFormatter.iso8601Full.string(from: updatedAt), forKey: .updatedAt)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        objectId = try container.decodeIfPresent(String.self, forKey: .objectId)
        title = try container.decode(String.self, forKey: .title)
        options = try container.decode([String].self, forKey: .options)
        user = try container.decode(Pointer<User>.self, forKey: .user)
        ACL = try container.decodeIfPresent(ParseACL.self, forKey: .ACL)
        
        if let createdAtString = try container.decodeIfPresent(String.self, forKey: .createdAt) {
            createdAt = DateFormatter.iso8601Full.date(from: createdAtString)
        }
        
        if let updatedAtString = try container.decodeIfPresent(String.self, forKey: .updatedAt) {
            updatedAt = DateFormatter.iso8601Full.date(from: updatedAtString)
        }
    }
}

