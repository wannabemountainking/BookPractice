//
//  TravellerViewModel.swift
//  BookPractice
//
//  Created by YoonieMac on 5/19/26.
//

import Foundation
import Observation


@MainActor
@Observable
final class TravellerViewModel {
	
	private let service: WeatherFetchService = .shared
	let cities: [String] = ["서울", "뉴욕", "런던", "도쿄", "파리", "모스크바"]
	
	var cityWeathers: [CityhWeather] = []
	var isLoading: Bool = false
	var elapedTime: String = ""
	
	func fetchAllWeathers() async {
		let startTime = Date()
        self.cityWeathers = []
		self.isLoading = true
		await withTaskGroup(of: CityhWeather.self) { group in
			for city in cities {
				group.addTask {
					
					let temper = await self.service.fetchWeather(city: city)
					return CityhWeather(
						city: city,
						temperature: temper,
						fetchedAt: Date()
					)
				}
			}
			for await result in group {
                self.cityWeathers.append(result)
			}
		}
		self.isLoading = false
		elapedTime = Date().timeIntervalSince(startTime).formatted(.number.precision(.fractionLength(2)))
	}
	
	func clearAll() {
		self.cityWeathers = []
	}
}
