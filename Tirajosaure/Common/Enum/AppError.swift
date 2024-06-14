//
//  AppError.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import Foundation

/// An enumeration representing different types of errors that can occur in the app.
enum AppError: Error, LocalizedError {
    case networkError(String)
    case authenticationError(String)
    case validationError(String)
    case parseError(String)
    case unknownError

    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "network_error_message".localized(with: message)
        case .authenticationError(let message):
            return "authentication_error_message".localized(with: message)
        case .validationError(let message):
            return "validation_error_message".localized(with: message)
        case .parseError(let message):
            return "parse_error_message".localized(with: message)
        case .unknownError:
            return ErrorMessage.unknownError.rawValue
        }
    }
}
