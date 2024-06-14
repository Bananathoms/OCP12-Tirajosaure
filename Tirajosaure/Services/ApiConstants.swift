//
//  ApiConstants.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 14/06/2024.
//

import Foundation

/// Constants for API endpoints and parameter keys
struct APIConstants {
    struct Endpoints {
        static let signUp = "/users"
        static let logIn = "/login"
        static let requestPasswordReset = "/requestPasswordReset"
    }
    
    struct Parameters {
        static let username = "username"
        static let email = "email"
        static let password = "password"
        static let firstName = "firstName"
        static let lastName = "lastName"
    }
    
    struct Headers {
        static let applicationID = "X-Parse-Application-Id"
        static let clientKey = "X-Parse-Client-Key"
        static let contentType = "Content-Type"
    }
}
