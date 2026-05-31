//
//  NetworkPractice.swift
//  BookPractice
//
//  Created by YoonieMac on 5/30/26.
//

import Foundation


enum NetworkError: Error, LocalizedError {
	case invalidURL
	case invalidResponse
	case parsingError
	case networkError
}

final class KakaoService {
	
	static let shared = KakaoService()
	private let baseURLString: String = "https://dapi.kakao.com/v3/search/book"
	private let apiKey: String = {
		guard let key = Bundle.main.infoDictionary?["KAKAO_API_KEY"] as? String else {
			return "인증키 없음"
		}
		return key
	}()
	
	private init() {}
	
	
	private func createURL(query: String, page: Int, size: Int) -> URL? {
		var components = URLComponents(string: baseURLString)
		components?.queryItems = [
			URLQueryItem(name: "query", value: query),
			URLQueryItem(name: "page", value: "\(page)"),
			URLQueryItem(name: "size", value: "\(size)")
		]
		return components?.url
	}
	
	func searchBooks(query: String, page: Int = 1, size: Int = 20) async throws -> BookResponse {
		guard let url = createURL(query: query, page: page, size: size) else {
			throw NetworkError.invalidURL
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.setValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")
		
		do {
			let (data, res) = try await URLSession.shared.data(for: request)
			print((res as? HTTPURLResponse)?.statusCode ?? -1)
			guard let response = res as? HTTPURLResponse,
				  (200 ..< 300).contains(response.statusCode) else {
				throw NetworkError.invalidResponse
			}
			
			do {
				return try JSONDecoder().decode(BookResponse.self, from: data)
				
			} catch {
				throw NetworkError.parsingError
			}
			
		} catch let error as NetworkError {
			throw error
		} catch {
			throw NetworkError.networkError
		}
	}
}
