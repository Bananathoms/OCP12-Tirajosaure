//
//  OptionsController.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 17/06/2024.
//

import Foundation
import SwiftUI
import Combine

class OptionsController: ObservableObject {
    @Published var options: [String] = []

    func addOption() {
        options.insert("", at: 0)
    }
    
    func removeOption(at offsets: IndexSet) {
        options.remove(atOffsets: offsets)
    }
    
    func moveOption(from source: IndexSet, to destination: Int) {
        options.move(fromOffsets: source, toOffset: destination)
    }
}
