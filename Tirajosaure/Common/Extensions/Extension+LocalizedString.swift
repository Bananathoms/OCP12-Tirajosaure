//
//  Extension+LocalizedString.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 14/06/2024.
//

import Foundation

extension LocalizedString {
    /// Returns the localized version of the enum's raw value.
    var localized: String {
        return rawValue.localized
    }

    /// Returns the localized string with arguments.
    /// - Parameter arguments: The arguments to format the string.
    /// - Returns: A formatted localized string.
    func localized(with arguments: CVarArg...) -> String {
        return rawValue.localized(with: arguments)
    }
}
