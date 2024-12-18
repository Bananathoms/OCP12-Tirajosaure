//
//  LanguageController.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 30/06/2024.
//

import Foundation
import Combine
import SwiftUI

class LanguageController: ObservableObject {
    static let shared = LanguageController()
    @Published var currentLanguage: String
    
    private init() {
        // Récupérer la langue préférée du téléphone
        let preferredLanguage = Locale.preferredLanguages.first?.prefix(2) ?? "en"
        // Utiliser la langue préférée si aucune langue n'est stockée dans UserDefaults
        self.currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? String(preferredLanguage)
        
        // Définir la langue lors de l'initialisation
        Bundle.setLanguage(currentLanguage)
    }
    
    func setLanguage(languageCode: String) {
        self.currentLanguage = languageCode
        UserDefaults.standard.set(languageCode, forKey: "selectedLanguage")
        Bundle.setLanguage(languageCode)
        NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)
    }
    
    func getCurrentLanguage() -> String {
        return currentLanguage
    }
}
