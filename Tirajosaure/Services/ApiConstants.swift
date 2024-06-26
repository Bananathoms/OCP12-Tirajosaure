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
        static let eventBase = "/classes/Event"
        static let eventById = "/classes/Event/{id}"
        static let teamBase = "/classes/Team"
        static let teamById = "/classes/Team/{id}"
        static let memberBase = "/classes/Member"
        static let memberById = "/classes/Member/{id}"
    }
    
    struct Parameters {
        //user
        static let username = "username"
        static let email = "email"
        static let password = "password"
        static let firstName = "firstName"
        static let lastName = "lastName"
        //question
        static let title = "title"
        static let options = "options"
        static let user = "user"
        //drawResult
        static let option = "option"
        static let date = "date"
        static let question = "question"
        // Event
        static let equitableDistribution = "equitableDistribution"
        // Team
        static let name = "name"
        static let event = "event"
        // Member
        static let team = "team"
        
        protocol PointerType {
            var className: String { get }
            var parameterName: String { get }
        }

        struct UserPointer: PointerType {
            let className = "_User"
            let parameterName = "user"
        }

        struct QuestionPointer: PointerType {
            let className = "Question"
            let parameterName = "question"
        }
        
        struct EventPointer: PointerType {
            let className = "Event"
            let parameterName = "event"
        }

        struct TeamPointer: PointerType {
            let className = "Team"
            let parameterName = "team"
        }
        
        static func pointerParams(className: String, objectId: String) -> [String: Any] {
            return [
                "__type": "Pointer",
                "className": className,
                "objectId": objectId
            ]
        }
        
        static func wherePointer(type: PointerType, objectId: String) -> [String: Any] {
            return [
                "where": [
                    type.parameterName: pointerParams(className: type.className, objectId: objectId)
                ]
            ]
        }
        
        static func dateParameter(from date: Date) -> [String: Any] {
            return [
                "__type": "Date",
                "iso": DateFormatter.iso8601Full.string(from: date)
            ]
        }
    }
    
    struct Headers {
        static let applicationID = "X-Parse-Application-Id"
        static let clientKey = "X-Parse-Client-Key"
        static let contentType = "Content-Type"
    }
}
