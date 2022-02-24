//
//  Language.swift
//  LocalPub
//
//  Created by Junseo Park on 2/17/22.
//

import Foundation

struct LanguageInfo: Codable {
    var language: Language
    var level: Level
}

enum Language: String, Codable {
    case english = "English"
    case korean = "Korean"
    case japanese = "Japanese"
    case russian = "Russian"
    case chinese = "Chinese"
    case ukraine = "Ukraine"
    case french = "French"
    case german = "German"
    case italian = "Italian"
    case spanish = "Spanish"

    func toString() -> String {
        return self.rawValue
    }
}

enum Level: String, Codable {
    case native = "Native"
    case fluent = "Fluent"
    case good = "Good"
    case soso = "Soso"
    case little = "Little"
    
    func toString() -> String {
        return self.rawValue
    }
}
