//
//  OptionsController.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 17/06/2024.
//

import Foundation
import SwiftUI
import Combine

/// A controller class responsible for managing the list of options for a question.
class OptionsController: ObservableObject {
    @Published var options: [String] = [] 
    
    /// Adds a new option to the list of options.
    func addOption() {
        self.options.insert(DefaultValues.emptyString, at: 0)
    }
    
    /// Removes an option from the list.
    /// - Parameter offsets: The set of indices specifying the options to be removed.
    func removeOption(at offsets: IndexSet) {
        self.options.remove(atOffsets: offsets)
    }
    
    /// Moves an option from one position to another within the list.
    /// - Parameters:
    ///   - source: The set of indices specifying the current positions of the options to be moved.
    ///   - destination: The index specifying the new position for the options.
    func moveOption(from source: IndexSet, to destination: Int) {
        self.options.move(fromOffsets: source, toOffset: destination)
    }
    
    /// Calculates the height of the list based on the number of options.
    func calculateListHeight() -> CGFloat {
        let baseHeight: CGFloat = 100.0
        let rowHeight: CGFloat = 44.0 
        return baseHeight + (rowHeight * CGFloat(options.count))
    }
}
