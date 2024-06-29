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
        static let questionsBase = "/classes/Question"
        static let questionById = "/classes/Question/{id}"
        static let drawResultBase = "/classes/DrawResult"
        static let drawResultById = "/classes/DrawResult/{id}"
        static let eventBase = "/classes/Event"
        static let eventById = "/classes/Event/{id}"
        static let teamsDrawBase = "/classes/TeamsDraw"
        static let teamsDrawById = "/classes/TeamsDraw/{objectId}"
        static let teamResultBase = "/classes/TeamResult"
        static let teamResultById = "/classes/TeamResult/{objectId}"
    }
    
    struct Parameters {
        static let username = "username"
        static let email = "email"
        static let password = "password"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let title = "title"
        static let option = "option"
        static let options = "options"
        static let user = "user"
        static let equitableDistribution = "equitableDistribution"
        static let teams = "teams"
        static let members = "members"
        static let objectId = "objectId"
        static let date = "date"
        static let question = "question"
        static let teamsDrawBase = "teamsDrawBase"
        static let event = "event"
        static let teamResultBase = "teamResultBase"
        static let name = "name"
        static let draw = "draw"
        
        /// Protocol defining the necessary properties for pointer types.
        protocol PointerType {
            var className: String { get }
            var parameterName: String { get }
        }
        
        /// User pointer for API requests.
        struct UserPointer: PointerType {
            let className = "_User"
            let parameterName = "user"
        }
        
        /// Question pointer for API requests.
        struct QuestionPointer: PointerType {
            let className = "Question"
            let parameterName = "question"
        }
        
        /// Event pointer for API requests.
        struct EventPointer: PointerType {
            let className = "Event"
            let parameterName = "event"
        }
        
        /// TeamsDraw pointer for API requests.
        struct TeamsDrawPointer: PointerType {
            let className = "TeamsDraw"
            let parameterName = "draw"
        }
        
        /// Constructs the parameters for a pointer object.
        /// - Parameters:
        ///   - className: The class name of the pointer.
        ///   - objectId: The object ID of the pointer.
        /// - Returns: A dictionary representing the pointer parameters.
        static func pointerParams(className: String, objectId: String) -> [String: Any] {
            return [
                "__type": "Pointer",
                "className": className,
                "objectId": objectId
            ]
        }
        
        /// Constructs the "where" parameters for a pointer query.
        /// - Parameters:
        ///   - type: The pointer type.
        ///   - objectId: The object ID of the pointer.
        /// - Returns: A dictionary representing the "where" parameters.
        static func wherePointer(type: PointerType, objectId: String) -> [String: Any] {
            return [
                "where": [
                    type.parameterName: pointerParams(className: type.className, objectId: objectId)
                ]
            ]
        }
        
        /// Constructs the date parameters for a date query.
        /// - Parameter date: The date to be used in the query.
        /// - Returns: A dictionary representing the date parameters.
        static func dateParameter(from date: Date) -> [String: Any] {
            return [
                "__type": "Date",
                "iso": DateFormatter.iso8601Full.string(from: date)
            ]
        }
    }
    
    /// Headers used in API requests.
    enum Headers: String {
        case applicationID = "X-Parse-Application-Id"
        case clientKey = "X-Parse-Client-Key"
        case contentType = "Content-Type"
    }
}
