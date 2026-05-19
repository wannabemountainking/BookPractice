//
//  ExchangeRateViewModel.swift
//  BookPractice
//
//  Created by YoonieMac on 5/19/26.
//

import Foundation
import Observation


@MainActor
@Observable
final class ExchangeRateViewModel {
	
	private let cache: ExchangeRateCache = .shared
	
	var currentExchangeRate: ExchangeRate?
	var currentExchangeRateCount: Int?
	var showCacheHit: Bool = false
	
	
	func getExchangeRate(currency: String) async {
		// cache에서 cacheResult를 가져와서 hit일 경우 actor에서 값을 가져오고 아닐 경우 더미 API에서 값을 가져온다
		let result = await fetchRate(currency: currency)
		switch result {
		case .hit(let exchangeRate):
			await self.fetchExchangeRateCount()
			self.showCacheHit = true
			self.currentExchangeRate = exchangeRate
		case .miss:
			let rate = getDummy(currency: currency)
			await self.saveRate(currency: rate.currency, rate: rate.rate)
			await self.fetchExchangeRateCount()
			self.showCacheHit = false
			self.currentExchangeRate = rate
		}
	}
	
	func clearCache() async {
		await cache.clearCache()
		await self.fetchExchangeRateCount()
		self.currentExchangeRate = nil
		self.showCacheHit = false
	}
	
	private func getDummy(currency: String) -> ExchangeRate {
		return ExchangeRate(
			currency: currency,
			rate: Double.random(in: 1450.00 ... 1550.00),
			cachedAt: Date()
		)
	}
	
	private func fetchExchangeRateCount() async {
		self.currentExchangeRateCount = await cache.getCacheCount()
	}
	
	private func fetchRate(currency: String) async -> CacheResult {
		await cache.getRate(currency: currency)
	}
	
	private func saveRate(currency: String, rate: Double) async {
		await cache.saveRate(currency: currency, rate: rate)
	}
	

}
