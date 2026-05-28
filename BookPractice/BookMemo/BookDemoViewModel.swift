//
//  BookDemoViewModel.swift
//  BookPractice
//
//  Created by yoonie on 5/24/26.
//

import Foundation
import Observation


@MainActor
@Observable
final class BookDemoViewModel {
    
    private let cacheService = CacheService.shared
    private let networkService = BookNetworkService.shared
    
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var currentBooks: [Book] = []
	
    init() {
//        self.currentBooks = Book.mockList
		print("init 실행됨: \(currentBooks.count)권")
        self.sortOptions(option: .titleAsc)
		print("정렬 후: \(currentBooks.count)권")
    }
    
	func searchBooks(text: String, size: Int = 20, pages: Int = 1) async {
        self.isLoading = true
        do {
            let result = try await cacheService.searchBooksInCache(query: text)
            if let result {
                self.currentBooks = result
            } else {
				self.currentBooks = try await networkService.searchBooksFromKakaoData(query: text, size: size, pages: pages)
				await cacheService.saveBooksToCache(searchingText: text, books: self.currentBooks)
            }
        } catch let err as BookError {
            switch err {
            case .invalidURL:
                self.errorMessage = "URL 오류"
            case .invalidResponse:
                self.errorMessage = "서버 응답 오류"
            }
        } catch {
            self.errorMessage = "알 수 없는 에러 발생: \(error.localizedDescription)"
        }
        self.isLoading = false
    }
    
    // 정렬 함수
    func sortOptions(option: SortOption) {
        self.isLoading = true
        switch option {
        case .priceDesc:
            self.currentBooks.sort(by: { $0.price > $1.price })
        case .priceAsc:
            self.currentBooks.sort(by: { $0.price < $1.price })
        case .titleAsc:
            self.currentBooks.sort(by: { $0.title < $1.title })
        }
        self.isLoading = false
    }
}
