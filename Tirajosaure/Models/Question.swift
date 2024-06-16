//
//  Question.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 15/06/2024.
//

import Foundation
import SwiftUI

struct Question: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var options: [String]
}
