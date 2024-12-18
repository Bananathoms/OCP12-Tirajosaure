//
//  Extension+Collection.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 17/06/2024.
//

import Foundation

extension Collection {
    /// Safely access the element at the specified index.
    /// - Parameter index: The index of the element to access.
    /// - Returns: The element at the specified index if it is within bounds,
    ///   otherwise `nil`.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
