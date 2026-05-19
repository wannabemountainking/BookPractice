//
//  WeatherFetchService.swift
//  BookPractice
//
//  Created by YoonieMac on 5/19/26.
//

import Foundation


final class WeatherFetchService {
	
	static let shared = WeatherFetchService()
	
	private init() {}
	
	func fetchWeather(city: String) async -> Double {
		try? await Task.sleep(for: .seconds(Double.random(in: 0.5 ... 2.0)))
		return Double.random(in: -10.0 ... 35.0)
	}
}
