//
//  ExchangeRateCache.swift
//  BookPractice
//
//  Created by YoonieMac on 5/19/26.
//

import Foundation


actor ExchangeRateCache {
	
	static let shared = ExchangeRateCache()
	
	var exchangeRateInfos: [String: ExchangeRate] = [:]
	
	private init() {}
	
	func getRate(currency: String) -> CacheResult {
		
		guard let currencyExchangeRate = exchangeRateInfos[currency] else {
			return CacheResult.miss
		}
		// 통화별 환율 딕셔너리에 특정 통화의 isExpired 속성 값 변경
		self.exchangeRateInfos[currency]?.isExpired = checkExpired(currencyExchangeRate)
		
		if currencyExchangeRate.isExpired {
			return CacheResult.miss
		} else {
			return CacheResult.hit(currencyExchangeRate)
		}
	}
	
	func saveRate(currency: String, rate: Double) {
		let exchangeRate = ExchangeRate(
			currency: currency,
			rate: rate,
			cachedAt: Date()
		)
		self.exchangeRateInfos[currency] = exchangeRate
	}
	
	func clearCache() {
		self.exchangeRateInfos.removeAll()
	}
	
	func getCacheCount() -> Int {
		self.exchangeRateInfos.count
	}
	
	private func checkExpired(_ rate: ExchangeRate) -> Bool {
		Date().timeIntervalSince(rate.cachedAt) > 300
	}
}
