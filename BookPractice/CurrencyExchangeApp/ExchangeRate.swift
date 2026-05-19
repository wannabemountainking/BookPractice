//
//  ExchangeRate.swift
//  BookPractice
//
//  Created by yoonie on 5/18/26.
//

import Foundation


struct ExchangeRate {
    let currency: String
    var rate: Double
    var cachedAt: Date
	var isExpired: Bool = false
}

extension ExchangeRate {
    var rateText: String {
        return "1 \(self.currency) = \(self.rate.formatted(.number.precision(.fractionLength(2)))) KRW"
    }
    var cachedTimeText: String {
        return "캐시 저장: \(self.cachedAt.timeFormatted)"
    }
}

extension Date {
    var timeFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: self)
    }
}
