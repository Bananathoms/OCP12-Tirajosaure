//
//  Format.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 20/06/2024.
//

import Foundation

enum Format: String {
    case percent = "%.1f%%"
    
    var key: String {
        return self.rawValue
    }
}
