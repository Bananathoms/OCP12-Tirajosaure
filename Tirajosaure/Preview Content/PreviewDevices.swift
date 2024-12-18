//
//  PreviewDevices.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 14/06/2024.
//

import Foundation
import SwiftUI

enum PreviewDevices: String {
    case iPhoneSE = "iPhone SE (3rd generation)"
    case iPhone14Pro = "iPhone 14 Pro"

    var previewDevice: PreviewDevice {
        return PreviewDevice(rawValue: self.rawValue)
    }

    var displayName: String {
        return self.rawValue
    }
}
