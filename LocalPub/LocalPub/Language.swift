//
//  Language.swift
//  LocalPub
//
//  Created by Junseo Park on 2/17/22.
//

import Foundation

struct MyUserLangages {
    let nativeLanguage: LanguageInfo
    var foreignLanguages: [LanguageInfo]
}

struct LanguageInfo {
    var language: Language
    var level: Level
}

enum Language {
    case english, korean, japanese, russian, chinese, ukraine

    var description: String {
        switch self {
        case .english:
            return "English"
        case .korean:
            return "Korean"
        case .japanese:
            return "Japanese"
        case .russian:
            return "Russian"
        case .chinese:
            return "Chinese"
        case .ukraine:
            return "Ukraine"
        }
    }

}

enum Level {
    case native, fluent, good, soso, little
    
    var description: String {
        switch self {
        case .native:
            return "Native"
        case .fluent:
            return "Fluent"
        case .good:
            return "good"
        case .soso:
            return "soso"
        case .little:
            return "Little"
        }
    }
}




