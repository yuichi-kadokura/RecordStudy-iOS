//
//  Date+Formatter.swift
//  RecordStudy
//
//  Created by 角倉 優一 on 2018/06/20.
//  Copyright © 2018年 角倉 優一. All rights reserved.
//

import Foundation

extension Date {
    public func toYMD() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: self)
    }

    
    func toHmKanji() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "H時間 m分"
        return dateFormatter.string(from: self)
    }
    
    func toHmm() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "H:mm"
        return dateFormatter.string(from: self)
    }

    func toYMDKanji() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "Y年 M月 d日"
        return dateFormatter.string(from: self)
    }

    func toYMDEKanji() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "Y年 M月 d日 (E)"
        return dateFormatter.string(from: self)
    }

    public init(timeIntervalSince1970jp: TimeInterval) {
        self.init(year: 1970, month: 1, day: 1)
    }

    public init(year: Int, month: Int, day: Int) {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ja_JP")
        
        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = TimeZone(identifier: "Asia/Tokyo")
        components.era = nil
        components.year = year
        components.month = month
        components.day = day
        components.hour = 0
        components.minute = 0
        components.second = 0
        components.nanosecond = 0
        self = calendar.date(from: components)!
    }
    
    public var isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }

}

