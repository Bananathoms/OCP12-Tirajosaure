//
//  TeamResult.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 27/06/2024.
//

import Foundation
import ParseSwift

struct TeamResult: ParseObject, Identifiable {
    var originalData: Data?
    
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var name: String
    var members: [String]
    var draw: Pointer<TeamsDraw>

    init(name: String, members: [String], draw: Pointer<TeamsDraw>) {
        self.name = name
        self.members = members
        self.draw = draw
    }

    // Required initializer for conforming to ParseObject
    init() {
        self.name = DefaultValues.emptyString
        self.members = []
        self.draw = Pointer<TeamsDraw>(objectId: DefaultValues.emptyString)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        objectId = try container.decodeIfPresent(String.self, forKey: .objectId)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        ACL = try container.decodeIfPresent(ParseACL.self, forKey: .ACL)
        name = try container.decode(String.self, forKey: .name)
        members = try container.decode([String].self, forKey: .members)
        draw = try container.decode(Pointer<TeamsDraw>.self, forKey: .draw)
    }
}
