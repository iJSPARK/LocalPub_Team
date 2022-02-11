//
//  ContryCode.swift
//  LocalPub
//
//  Created by Junseo Park on 2/6/22.
//

// enum으로 지역 여러개
// 뷰 (테이블/컬렉션) 올림
// 모델 (데이터 입력, 업로드)
// 국기 이모지 빼고 phonenmber 문자열 앞에다 붙임
// 디폴드 값 = 유저 (iso ㅣocation)

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

let countryCodeInfos: [Country] = [
    Country(countryEmoji: "🇰🇷", countryName: "Korea", countryCode: "+82"),
    Country(countryEmoji: "🇺🇸", countryName: "US", countryCode: "+1"),
    Country(countryEmoji: "🇯🇵", countryName: "Japen", countryCode: "+81")
]
