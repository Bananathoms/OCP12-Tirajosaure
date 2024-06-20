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
    case pencilCircle = "pencil.circle"
    case pencil = "pencil"
    case person3 = "person.3"
    case gearshape = "gearshape"
    case plusCircleFill = "plus.circle.fill"
    case checkmarkCircleFill = "checkmark.circle.fill"
    case pencilCircleFill = "pencil.circle.fill"
    case chartBar = "chart.bar"
    case listBullet = "list.bullet"

    var image: Image {
        return Image(self.rawValue)
    }
    
    var systemImage: Image {
        return Image(systemName: self.rawValue)
    }
}
