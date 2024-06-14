//
//  UserDefaultsKeys.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 14/06/2024.
//

import Foundation

enum UserDefaultsKeys: String {
    case hasLaunchedBefore

    var key: String {
        return self.rawValue
    }
}
