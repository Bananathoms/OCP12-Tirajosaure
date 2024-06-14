//
//  ErrorMessage.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 14/06/2024.
//

import Foundation

enum ErrorMessage: String {
    case failedToRequestPasswordReset = "Failed to request password reset"
    case failedToDecodeJSONResponse = "Failed to decode JSON response"
    case unknownError = "An unknown error occurred"
    case defaultMessage = "No response string"
}
