//
//  DrawResult.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 19/06/2024.
//

import Foundation
import ParseSwift

/// A struct representing the result of a draw operation in the Tirajosaure app.
struct DrawResult: ParseObject, Identifiable, Codable {
    var originalData: Data?

    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    let option: String
    let date: Date
    
    var question: Pointer<Question>

    init(option: String, date: Date, question: Pointer<Question>) {
        self.option = option
        self.date = date
        self.question = question
    }

    // Required initializer for conforming to ParseObject
    init() {
        self.option = DefaultValues.emptyString
        self.date = Date()
        self.question = Pointer<Question>(objectId: DefaultValues.emptyString)
    }
    
    enum CodingKeys: String, CodingKey {
        case objectId, createdAt, updatedAt, ACL, option, date, question
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        objectId = try container.decodeIfPresent(String.self, forKey: .objectId)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        ACL = try container.decodeIfPresent(ParseACL.self, forKey: .ACL)
        option = try container.decode(String.self, forKey: .option)
        question = try container.decode(Pointer<Question>.self, forKey: .question)
        
        if let dateString = try container.decodeIfPresent([String: String].self, forKey: .date)?["iso"],
           let dateValue = DateFormatter.iso8601Full.date(from: dateString) {
            date = dateValue
        } else {
            date = try container.decode(Date.self, forKey: .date)
        }
    }
}
