//
//  CustomFont.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 14/06/2024.
//

import Foundation
import SwiftUI

/// Enum to represent custom fonts.
enum CustomFont: String {
    case nunitoSemiBold = "Nunito-SemiBold"
    case nunitoBold = "Nunito-Bold"
    case nunitoLight = "Nunito-Light"
    case nunitoRegular = "Nunito-Regular"
    case nunitoMedium = "Nunito-Medium"
    
    /// Returns a Font object with the specified size.
    /// - Parameter size: The size of the font. Default is 26.
    /// - Returns: A Font object with the specified size.
    func font(size: CGFloat = 26) -> Font {
        return .custom(self.rawValue, size: size)
    }
}
