//
//  AppLanguage.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 30/06/2024.
//

import Foundation

enum AppLanguage: String, CaseIterable {
    case armenian = "hy"
    case basque = "eu"
    case belarusian = "be"
    case breton = "br"
    case bulgarian = "bg"
    case catalan = "ca"
    case chinese = "zh"
    case corsican = "co"
    case croatian = "hr"
    case czech = "cs"
    case danish = "da"
    case dutch = "nl"
    case english = "en"
    case estonian = "et"
    case filipino = "fil"
    case finnish = "fi"
    case french = "fr"
    case georgian = "ka"
    case german = "de"
    case greek = "el"
    case hindi = "hi"
    case hungarian = "hu"
    case indonesian = "id"
    case italian = "it"
    case japanese = "ja"
    case klingon = "tlh"
    case korean = "ko"
    case latin = "la"
    case malay = "ms"
    case norwegianBokmal = "nb"
    case polish = "pl"
    case portuguese = "pt-PT"
    case romanian = "ro"
    case russian = "ru"
    case slovak = "sk"
    case slovenian = "sl"
    case spanish = "es"
    case swedish = "sv"
    case thai = "th"
    case turkish = "tr"
    case ukrainian = "uk"
    case vietnamese = "vi"

    var displayName: String {
        switch self {
        case .armenian:
            return "Հայերեն"
        case .basque:
            return "Euskara"
        case .belarusian:
            return "Беларуская"
        case .breton:
            return "Brezhoneg"
        case .bulgarian:
            return "Български"
        case .catalan:
            return "Català"
        case .chinese:
            return "中文"
        case .corsican:
            return "Corsu"
        case .croatian:
            return "Hrvatski"
        case .czech:
            return "Čeština"
        case .danish:
            return "Dansk"
        case .dutch:
            return "Nederlands"
        case .english:
            return "English"
        case .estonian:
            return "Eesti"
        case .filipino:
            return "Filipino"
        case .finnish:
            return "Suomi"
        case .french:
            return "Français"
        case .georgian:
            return "ქართული"
        case .german:
            return "Deutsch"
        case .greek:
            return "Ελληνικά"
        case .hindi:
            return "हिन्दी"
        case .hungarian:
            return "Magyar"
        case .indonesian:
            return "Bahasa Indonesia"
        case .italian:
            return "Italiano"
        case .japanese:
            return "日本語"
        case .klingon:
            return "tlhIngan"
        case .korean:
            return "한국어"
        case .latin:
            return "Latina"
        case .malay:
            return "Bahasa Melayu"
        case .norwegianBokmal:
            return "Norsk Bokmål"
        case .polish:
            return "Polski"
        case .portuguese:
            return "Português"
        case .romanian:
            return "Română"
        case .russian:
            return "Русский"
        case .slovak:
            return "Slovenčina"
        case .slovenian:
            return "Slovenščina"
        case .spanish:
            return "Español"
        case .swedish:
            return "Svenska"
        case .thai:
            return "ไทย"
        case .turkish:
            return "Türkçe"
        case .ukrainian:
            return "Українська"
        case .vietnamese:
            return "Tiếng Việt"
        }
    }
}
