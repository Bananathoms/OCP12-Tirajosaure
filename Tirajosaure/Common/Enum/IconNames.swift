//
//  IconNames.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 14/06/2024.
//

import Foundation
import SwiftUI

enum IconNames: String {
    case logo = "logo"
    case at = "at"
    case lock = "lock"
    case back = "chevron.backward"

    var image: Image {
        return Image(self.rawValue)
    }
    
    var systemImage: Image {
        return Image(systemName: self.rawValue)
    }
}
