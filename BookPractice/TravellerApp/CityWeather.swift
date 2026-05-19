//
//  CityWeather.swift
//  BookPractice
//
//  Created by YoonieMac on 5/19/26.
//

import Foundation


struct CityhWeather {
	let city: String
	let temperature: Double
	let fetchedAt: Date
}

extension CityhWeather {
	var temperatureText: String {
		"\(city): \(temperature.formatted(.number.precision(.fractionLength(1))))℃"
	}
	var fetchedTimeText: String {
		"조회 시각: \(fetchedAt.timeFormatted)"
	}
}
