//
//  Extension+Font.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import Foundation
import SwiftUI

/// An extension to the `Font` struct to include custom fonts.
extension Font {
    static func customFont(_ customFont: CustomFont, size: CGFloat = 26) -> Font {
        return customFont.font(size: size)
    }
}
