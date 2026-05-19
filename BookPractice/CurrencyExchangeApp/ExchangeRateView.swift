//
//  ExchangeRateView.swift
//  BookPractice
//
//  Created by YoonieMac on 5/19/26.
//

import SwiftUI

struct ExchangeRateView: View {
	
	@State private var vm: ExchangeRateViewModel = .init()
	@State private var currency: String = "USD"
	
    var body: some View {
		VStack(alignment: .leading, spacing: 50) {
			VStack(spacing: 15) {
				HStack {
					Text("Practice 02")
					Spacer()
				}
				HStack {
					Text("Codable + CodingKeys")
					Spacer()
				}
			} //:VSTACK
			.font(.largeTitle)
			.fontWeight(.ultraLight)
			
			HStack {
				Button(action: {
					Task {
						await self.vm.getExchangeRate(currency: currency)
					}
				}, label: {
					Text("환율 조회")
						.frame(maxWidth: .infinity)
				})
				.buttonStyle(.borderedProminent)
				
				Button(action: {
					Task {
						await self.vm.clearCache()
					}
				}, label: {
					Text("캐시 초기화")
						.frame(maxWidth: .infinity)
				})
				.buttonStyle(.borderedProminent)
			} //:HSTACK
			
			VStack {
				if let currentRate = self.vm.currentExchangeRate,
				   let currentRateCount = self.vm.currentExchangeRateCount {
					Text(currentRate.rateText)
					Text(currentRate.cachedTimeText)
					Text("캐시 항목 수: \(currentRateCount)")
				} else {
					Text("환율정보 확보 실패")
				}
			} //:VSTACK
			
			Text(self.vm.showCacheHit ? "✅ 캐시 히트" : "🌐 API 호출")
			
		} //:VSTACK
		.padding()
    }//:body
}

#Preview {
    ExchangeRateView()
}
