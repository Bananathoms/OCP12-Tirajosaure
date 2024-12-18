//
//  Extension+View.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import Foundation
import SwiftUI

/// An extension to the `View` struct to include a method for setting corner radius for specific corners.
extension View {
    
    /// Sets the corner radius for specific corners of the view.
    /// - Parameters:
    ///   - radius: The radius of the corners.
    ///   - corners: The specific corners to apply the radius to.
    /// - Returns: A view with the specified corner radius applied.
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

/// A struct representing a shape with rounded corners for specific corners.
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    /// Creates a path in the specified rectangle with rounded corners.
    /// - Parameter rect: The rectangle in which to create the path.
    /// - Returns: A path with the specified rounded corners.
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
