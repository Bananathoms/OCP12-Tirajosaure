//
//  AppError.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import Foundation

/// An enumeration representing different types of errors that can occur in the app.
enum AppError: Error, LocalizedError, Equatable  {
    case networkError(String)
    case authenticationError(String)
    case validationError(String)
    case parseError(String)
    case unknownError

    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return LocalizedString.networkErrorMessage.localized(with: message)
        case .authenticationError(let message):
            return LocalizedString.authenticationErrorMessage.localized(with: message)
        case .validationError(let message):
            return LocalizedString.validationErrorMessage.localized(with: message)
        case .parseError(let message):
            return LocalizedString.parseErrorMessage.localized(with: message)
        case .unknownError:
            return ErrorMessage.unknownError.rawValue
        }
    }
    
    static func == (lhs: AppError, rhs: AppError) -> Bool {
        switch (lhs, rhs) {
        case (.networkError(let lhsMessage), .networkError(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.authenticationError(let lhsMessage), .authenticationError(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.validationError(let lhsMessage), .validationError(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.parseError(let lhsMessage), .parseError(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.unknownError, .unknownError):
            return true
        default:
            return false
        }
    }
}
