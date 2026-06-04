//
//  HomeViewModel.swift
//  BookPractice
//
//  Created by YoonieMac on 6/1/26.
//

import Foundation
import Observation


@MainActor
@Observable
final class HomeViewModel {
	
	// 상수 값들
	private let categories: [String] = ["프로그래밍", "iOS", "SwiftUI", "전쟁", "금융"]
	private let kakaoService = KakaoService.shared
	private let cacheService = BookCacheActor.shared
	
	// View로 보낼 데이터 categoryResults: [String: [Book]]
	var categoryBooks: [String: [Book]] = [:]
	
	// 상태변경 변수(주요 메서드)
	// categoryLoading이 일어나고 있는지
	private var isLoadingCategoryStates: Bool = false
	// ErrMessage
	var errMessage: String?
	
	// 상태 변경 변수(loadMoreBooks 만)
	// category별 작업에서 각 category(query)의 현재 페이지는?
	private var categoryCurrentPage: [String: Int] = [:]
	// category별 작업에서 각 category(query)가 더 넘길 페이지가 있는지?
	var categoryHasMorePage: [String: Bool] = [:]
	// category별 개별 작업 상태가 어떠한가?
	private var categoryLoadingStates: [String: Bool] = [:]

	init() {
		Task {
			await self.loadInitialData()
		}
	}
	
	// 맨 처음 로딩
	func loadInitialData() async {
		isLoadingCategoryStates = true
		
		
		await withTaskGroup(of: (String, [Book]?).self) { [weak self] group in
			guard let self else { return }
			
			for category in categories {
				group.addTask {
					// 1. 우선 이. category가 categoryCached에 있는지 확인
					if let cached = await self.cacheService.getCacheResults(
						type: .category,
						query: category,
						page: 1
					) {
						await MainActor.run {
							self.categoryHasMorePage[category] = !cached.isEnd
						}
						// 1-1. 있으면 cached의 값 리턴
						return (category, cached.books)
					}
					
					// 1-2. 없으면 api 호출
					do {
						let fetchedBooks = try await self.fetchCategoryBooks(query: category, page: 1)
						
						await MainActor.run {
							self.categoryHasMorePage[category] = !fetchedBooks.isEnd
						}
						return (category, fetchedBooks.books)
					} catch {
                        await MainActor.run {
                            self.handleError(error)
                        }
					}
					return (category, nil)
				}
			}
			
			for await result in group {
				categoryBooks[result.0] = result.1
				categoryCurrentPage[result.0] = 1
				categoryLoadingStates[result.0] = false
			}
		}
		isLoadingCategoryStates = false
	}
	
	// 개별 카테고리의 책이 다음 페이지로 넘어가도록 하는 메서드
	func loadCategoryMore(category: String) async {
		
		// 0. 메서드가 작동할 상태 점검
		guard let hasMorePage = categoryHasMorePage[category], hasMorePage,
			  let loadingStates = categoryLoadingStates[category], !loadingStates else { return }
		
		defer {
			categoryLoadingStates[category] = false
			isLoadingCategoryStates = false
		}
		
		// 1. isLoadingCategory 상태 변경 true 등 상태변경
		isLoadingCategoryStates = true
		categoryLoadingStates[category] = true
		let currentPage = categoryCurrentPage[category] ?? 1
		let nextPage = currentPage + 1
		
		// 2. cache에 있으면 categoryBooks에 추가, 없으면 다음 단계
		if let cached = await self.cacheService.getCacheResults(
			type: .category,
			query: category,
			page: nextPage
		) {
			self.categoryHasMorePage[category] = !cached.isEnd
			self.categoryCurrentPage[category] = nextPage
			// categoryBooks에 추가
			if var existing = categoryBooks[category] {
				existing.append(contentsOf: cached.books)
				categoryBooks[category] = existing
			} else {
				categoryBooks[category] = cached.books
			}
		} else {
			// 3. cached에 없으면 api 호출
			do {
				let fetchedBooks = try await self.fetchCategoryBooks(query: category, page: nextPage)
				
				self.categoryHasMorePage[category] = !fetchedBooks.isEnd
				
				if var existing = categoryBooks[category] {
					existing.append(contentsOf: fetchedBooks.books)
					categoryBooks[category] = existing
				} else {
					categoryBooks[category] = fetchedBooks.books
				}
				
				// isLoadingCategory 등 상태변경 초기화 등
				categoryCurrentPage[category] = nextPage
			} catch {
				self.handleError(error)
			}
		}
	}
	
	private func fetchCategoryBooks(query: String, page: Int) async throws -> (books: [Book], isEnd: Bool) {
		// 받아온 값으로 [Book] 만들기
		let bookResponse = try await self.kakaoService.searchBooks(query: query, page: page)
		let docs = bookResponse.documents
		let meta = bookResponse.meta
		let newBooks = docs.map {
			Book(
				title: $0.title,
				authors: $0.authors,
				price: $0.salePrice,
				isbn: $0.isbn,
				thumbnailUrlString: $0.thumbnailUrlString,
				contents: $0.contents
			)
		}
		// 4. 받아온 값 cache 저장하기
		await self.cacheService.saveToCache(
			type: .category,
			query: query,
			page: page,
			books: newBooks,
			totalCount: meta.totalCount,
			isEnd: meta.isEnd
		)

		return (books: newBooks, isEnd: meta.isEnd)
	}
	
    private func handleError(_ error: Error) {
        if let err = error as? NetworkError {
            switch err {
            case .invalidURL:
                self.errMessage = "URL 오류"
            case .invalidResponse:
                self.errMessage = "서버 응답 오류"
            case .parsingError:
                self.errMessage = "데이터 파싱 오류"
            case .networkError:
                self.errMessage = "네트워크 오류"
            }
        }
    }
}
