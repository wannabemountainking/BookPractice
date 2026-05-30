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
	
	private let apiKey: String = {
		guard let key = Bundle.main.infoDictionary?["KAKAO_API_KEY"] as? String else {return "플랫폼 키가 없습니다"}
		   return key
	   }()
	
	private let basicURLString: String = "https://dapi.kakao.com/v3/search/book"
	
	private init() { }
	
	func createURL(query: String, page: Int, size: Int) -> URL? {
		var components = URLComponents(string: basicURLString)
		components?.queryItems = [
			URLQueryItem(name: "query", value: query),
			URLQueryItem(name: "page", value: "\(page)"),
			URLQueryItem(name: "size", value: "\(size)")
		]
		return components?.url
	}
	
	func searchBooks(query: String, page: Int = 1, size: Int = 1) async throws -> [Book]{
		guard let url = createURL(query: query, page: page, size: size) else {
			throw NetworkError.invalidURL
		}
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.setValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")
		
		print("Authorization: \(request.value(forHTTPHeaderField: "Authorization") ?? "없음")")
		print("URL: \(url)")
		
		do {
			let (data, res) = try await URLSession.shared.data(for: request)
			print("Status Code: \((res as? HTTPURLResponse)?.statusCode ?? -1)")
			guard let response = res as? HTTPURLResponse,
				  (200 ..< 300).contains(response.statusCode) else {
				throw NetworkError.invalidResponse
			}
			
			do {
				let decodedData = try JSONDecoder().decode(BookResponse.self, from: data)
				let bookInfo = decodedData.documents
				let bookMeta = decodedData.meta
				
				let books = bookInfo.map {
					Book(
						title: $0.title,
						authors: $0.authors,
						price: $0.salePrice,
						isbn: $0.isbn,
						thumbnailUrlString: $0.thumbnailUrlString,
						contents: $0.contents,
						isEnd: bookMeta.isEnd,
						totalCount: bookMeta.totalCount
					)
				}
				return books
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
