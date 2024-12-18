//
//  Extension+Date.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 07/06/2024.
//

import Foundation

// DateFormatter extension to handle ISO 8601 date formatting with fractional seconds.
extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
