//
//  SnackBarService.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import Foundation
import SwiftEntryKit

/// A service class responsible for displaying success and error messages using `SwiftEntryKit`.
class SnackBarService {
    static let current = SnackBarService()
    
    /// Displays a success message using `SwiftEntryKit`.
    /// - Parameter message: The success message to be displayed.
    func success(_ message: String) {
        SwiftEntryKit.showSuccesMessage(message: message)
    }
    
    /// Displays an error message using `SwiftEntryKit`.
    /// - Parameter message: The error message to be displayed.
    func error(_ message: String) {
        SwiftEntryKit.showErrorMessage(message: message)
    }
}
