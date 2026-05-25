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
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var currentBooks: [Book] = []
	
    init() {
//        self.currentBooks = Book.mockList
		print("init 실행됨: \(currentBooks.count)권")
        self.sortOptions(option: .titleAsc)
		print("정렬 후: \(currentBooks.count)권")
    }
    
    func searchBooks(text: String) async {
        self.isLoading = true
        do {
            self.currentBooks = try await cacheService.searchBooks(query: text)
        } catch let err as BookError {
            switch err {
            case .noSearchResult:
                self.errorMessage = "검색결과가 없습니다"
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
