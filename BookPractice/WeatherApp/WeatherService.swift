//
//  WeatherService.swift
//  BookPractice
//
//  Created by yoonie on 5/17/26.
//

import Foundation


final class WeatherService {
    
    // MARK: - Singleton Type Property
    static let shared = WeatherService()
    
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    // MARK: - Singleton Init
    private init() {}
    
    // MARK: - URL을 안전하게 생성하는 메서드
    private func createURL(city: String) -> URL? {
        guard var components = URLComponents(string: baseURL) else {return nil}
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: "dummy_api_key"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "kr")
        ]
        return components.url
    }
    
    func fetchWeather(city: String) async throws -> String {
        guard let url = createURL(city: city) else {throw WeatherError.invalidURL}
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let urlString = request.url?.absoluteString else { throw WeatherError.networkError }
        return urlString
    }
}
