//
//  Extension+SwiftEntryKit.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import Foundation
import SwiftUI
import SwiftEntryKit

/// An extension to `SwiftEntryKit` to provide custom methods for displaying success and error messages.
extension SwiftEntryKit {

    /// Displays a success message using `SwiftEntryKit`.
       /// - Parameter message: The success message to be displayed.
    static func showSuccesMessage(message: String) {
        var attributes = EKAttributes.topNote

        attributes.entryBackground = .color(color: .init(UIColor(.green)))
        attributes.roundCorners = .bottom(radius: 20)
        attributes.displayDuration = 4
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero))
     
        let font = UIFont(name: "Nunito-Bold", size: 15) ?? UIFont.systemFont(ofSize: 15)
        let style = EKProperty.LabelStyle(font: font, color: .white, alignment: .center)
        let labelContent = EKProperty.LabelContent(text: message, style: style)
        let contentView = EKNoteMessageView(with: labelContent)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    /// Displays an error message using `SwiftEntryKit`.
    /// - Parameter message: The error message to be displayed.
    static func showErrorMessage(message: String) {
        var attributes = EKAttributes.topNote

        attributes.entryBackground = .color(color: .init(UIColor(.customRed)))
        attributes.roundCorners = .bottom(radius: 20)
        attributes.displayDuration = .infinity
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero))
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .dismiss
     
        let font = UIFont(name: "Nunito-Bold", size: 15) ?? UIFont.systemFont(ofSize: 15)
        let style = EKProperty.LabelStyle(font: font, color: .white, alignment: .center)
        let labelContent = EKProperty.LabelContent(text: message, style: style)
        let contentView = EKNoteMessageView(with: labelContent)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}
