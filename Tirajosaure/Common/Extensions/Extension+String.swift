//
//  Extension+String.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import Foundation
import SwiftUI

/// An extension to the `String` struct to include custom validation methods.
extension String {
    private static let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
    private static let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
    private static let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,6}"
    
    /// Validates if the string is a valid email address.
    public var isValidEmail: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", type(of:self).__emailRegex)
        return predicate.evaluate(with: self)
    }
    
    /// Checks if the string contains at least one uppercase letter.
    /// - Returns: `true` if the string contains an uppercase letter, otherwise `false`.
    func hasUppercase() -> Bool {
        let passwordRegEx = "^(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`']{1,}$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: self)
    }
    
    /// Checks if the string contains at least one lowercase letter.
    /// - Returns: `true` if the string contains a lowercase letter, otherwise `false`.
    func hasLowercase() -> Bool {
        let passwordRegEx = "^(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`']{1,}$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: self)
    }
    
    /// Checks if the string is blank (contains only whitespace and newlines).
    /// - Returns: `true` if the string is blank, otherwise `false`.
    func isBlank() -> Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
