//
//  TeamsDraw.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 28/06/2024.
//

import Foundation
import ParseSwift

struct TeamsDraw: ParseObject, Identifiable {
    var originalData: Data?
    
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var date: Date
    var event: Pointer<Event>
    var teamResults: [TeamResult] = []

    init(date: Date, event: Pointer<Event>) {
        self.date = date
        self.event = event
        self.teamResults = []
    }

    // Required initializer for conforming to ParseObject
    init() {
        self.date = Date()
        self.event = Pointer<Event>(objectId: DefaultValues.emptyString)
        self.teamResults = []
    }

    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    enum CodingKeys: String, CodingKey {
        case objectId, createdAt, updatedAt, ACL, date, event
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        objectId = try container.decodeIfPresent(String.self, forKey: .objectId)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        ACL = try container.decodeIfPresent(ParseACL.self, forKey: .ACL)
        event = try container.decode(Pointer<Event>.self, forKey: .event)
        teamResults = []

        if let dateDict = try container.decodeIfPresent([String: String].self, forKey: .date),
           let dateString = dateDict["iso"],
           let dateValue = DateFormatter.iso8601Full.date(from: dateString) {
            date = dateValue
        } else {
            date = try container.decode(Date.self, forKey: .date)
        }
    }
}
