//
//  User.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import Foundation
import ParseSwift

/// A struct representing a user in the Parse server.
struct User: ParseUser {
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var sessionToken: String?
    var password: String?
    var authData: [String : [String : String]?]?
    var originalData: Data?
    var ACL: ParseSwift.ParseACL?
    var profilePicture: ParseFile?
    var firstName: String?
    var lastName: String?
}
