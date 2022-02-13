//
//  ContryCode.swift
//  LocalPub
//
//  Created by Junseo Park on 2/6/22.
//
// 초기값 = 유저 (iso ㅣocation)

import Foundation

struct Country {
    let countryEmoji: String // 국기 이모지
    let countryName: String // 국가 이름
    let countryCode: String // 국가 번호
    
    init(countryEmoji: String, countryName: String, countryCode: String) {
        self.countryEmoji = countryEmoji
        self.countryName = countryName
        self.countryCode = countryCode
    }
}

let countryInfo: [Country] = [
    Country(countryEmoji: "🇰🇷", countryName: "Korea", countryCode: "+82"),
    Country(countryEmoji: "🇺🇸", countryName: "US", countryCode: "+1"),
    Country(countryEmoji: "🇯🇵", countryName: "Japen", countryCode: "+81")
]
