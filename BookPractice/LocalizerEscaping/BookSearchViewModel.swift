//
//  BookSearchViewModel.swift
//  BookPractice
//
//  Created by YoonieMac on 5/31/26.
//

import Foundation
import Observation

@Observable
final class BookSearchViewModel {
	
	private let kakaoService = KakaoService.shared
	
	var books: [Book] = []
	var isLoading: Bool = false
	var hasMorePage: Bool = true
	var currentPage: Int = 1
	var errMessage: String?
	
	func searchBooks(query: String) async {
		books = []
		isLoading = true
		do {
			let bookResponse = try await kakaoService.searchBooks(query: query)
		} catch let error as NetworkError {
			switch error {
			case .invalidURL:
				self.errMessage = "URL 오류"
			case .invalidResponse:
				self.errMessage = "서버 응답 오류"
			case .parsingError:
				self.errMessage = "데이터 파싱 오류"
			case .networkError:
				self.errMessage = "네트워크 오류"
			}
		} catch {
			self.errMessage = "에러: \(error.localizedDescription)"
		}
		
		isLoading = false
	}
	
	func loadMore(query: String) async {
		
	}
}
