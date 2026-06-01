//
//  BookSearchViewModel.swift
//  BookPractice
//
//  Created by YoonieMac on 5/31/26.
//
//
//import Foundation
//import Observation
//
//@MainActor
//@Observable
//final class BookSearchViewModel {
//	
//	private let kakaoService = KakaoService.shared
//	
//	var books: [Book] = []
//	var isLoading: Bool = false
//	var hasMorePage: Bool = true
//	var currentPage: Int = 1
//	var errMessage: String?
//	
//	func searchBooks(query: String) async {
//		print("searchBooks 호출됨: \(query)")
//		books = []
//		isLoading = true
//		
//		currentPage = 1
//		do {
//			books = try await fetchBooks(query: query, page: currentPage)
//		} catch {
//			handleError(error)
//		}
//		print("books count: \(books.count)")
//		isLoading = false
//	}
//	
//	func loadMore(query: String) async {
//		
//		guard hasMorePage && isLoading == false else {
//			return
//		}
//		
//		isLoading = true
//		let nextPage = currentPage + 1
//		
//		do {
//			let newPageBooks = try await fetchBooks(query: query, page: nextPage)
//			books.append(contentsOf: newPageBooks)
//			currentPage = nextPage
//			
//		} catch {
//			handleError(error)
//		}
//		
//		isLoading = false
//	}
//	
//	private func fetchBooks(query: String, page: Int) async throws -> [Book] {
//		
//		do {
//			let bookResponse = try await kakaoService.searchBooks(query: query, page: page)
//			let docs = bookResponse.documents
//			let meta = bookResponse.meta
//			hasMorePage = !meta.isEnd
//			
//			return docs.map {
//				Book(
//					title: $0.title,
//					authors: $0.authors,
//					price: $0.salePrice,
//					isbn: $0.isbn,
//					thumbnailUrlString: $0.thumbnailUrlString,
//					contents: $0.contents
//				)
//			}
//		} catch let error as NetworkError {
//			throw error
//		} catch {
//			throw NetworkError.networkError
//		}
//	}
//	
//	private func handleError(_ error: Error) {
//		if let err = error as? NetworkError {
//			switch err {
//			case .invalidURL:
//				self.errMessage = "URL 오류"
//			case .invalidResponse:
//				self.errMessage = "서버 응답 오류"
//			case .parsingError:
//				self.errMessage = "데이터 파싱 오류"
//			case .networkError:
//				self.errMessage = "네트워크 오류"
//			}
//		} else {
//			self.errMessage = "에러: \(error)"
//		}
//	}
//}
