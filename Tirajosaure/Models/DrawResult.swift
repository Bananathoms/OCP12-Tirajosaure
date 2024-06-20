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
        self.option = ""
        self.date = Date()
        self.question = Pointer<Question>(objectId: "")
    }
}
