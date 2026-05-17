//
//  WeatherError.swift
//  BookPractice
//
//  Created by yoonie on 5/17/26.
//

import Foundation

enum WeatherError: LocalizedError {
    case invalidURL
    case networkError
    
    var errorDescription: String {
        switch self {
        case .invalidURL: return "URL이 잘못되었습니다"
        case .networkError: return "네트워크가 잘못되었습니다"
        }
    }
}
