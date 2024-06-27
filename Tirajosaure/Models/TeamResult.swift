//
//  TeamResult.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 27/06/2024.
//

import Foundation
import ParseSwift

/// A struct representing the result of a team distribution in the Tirajosaure app.
struct TeamResult: ParseObject, Identifiable, Codable {
    var originalData: Data?

    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var name: String
    var members: [String]
    
    var event: Pointer<Event>

    init(name: String, members: [String], event: Pointer<Event>) {
        self.name = name
        self.members = members
        self.event = event
    }

    // Required initializer for conforming to ParseObject
    init() {
        self.name = DefaultValues.emptyString
        self.members = []
        self.event = Pointer<Event>(objectId: DefaultValues.emptyString)
    }
    
    enum CodingKeys: String, CodingKey {
        case objectId, createdAt, updatedAt, ACL, name, members, event
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        objectId = try container.decodeIfPresent(String.self, forKey: .objectId)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        ACL = try container.decodeIfPresent(ParseACL.self, forKey: .ACL)
        name = try container.decode(String.self, forKey: .name)
        members = try container.decode([String].self, forKey: .members)
        event = try container.decode(Pointer<Event>.self, forKey: .event)
    }
}
