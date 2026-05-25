//
//  BookNetworService.swift
//  BookPractice
//
//  Created by YoonieMac on 5/25/26.
//

import Foundation

actor BookNetworService {
	
	static let shared = BookNetworService()
	
	private let kakao
	
	var booksFromKakaoData: [Book] = []
	
	
	private init() {}
	
	func searchBooksFromKakaoData(url: URL, query: String) async throws -> [Book] {
		
		
		return []
	}
	
	private func getURLRequest(urlString: String) throws -> URLRequest {
		guard let url = URL(string: urlString) else { throw BookError.invalidURL }
		let request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.allHTTPHeaderFields =
	}
}
