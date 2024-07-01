//
//  AppLanguage.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 30/06/2024.
//

import Foundation

enum AppLanguage: String, CaseIterable {
    case english = "en"
    case french = "fr"
    
    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .french:
            return "Français"
        }
    }
}
