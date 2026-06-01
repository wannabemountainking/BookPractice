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
	private var categoryHasMorePage: [String: Bool] = [:]
	// category별 개별 작업 상태가 어떠한가?
	private var categoryLoadingStates: [String: Bool] = [:]

	
	
	// 맨 처음 로딩
	func loadInitialData() async {
		isLoadingCategoryStates = true
		
		await withTaskGroup(of: (String, [Book]?).self) { [weak self] group in
			guard let self else { return }
			
			for category in categories {
				group.addTask {
					// 1. 우선 이. category가 categoryCached에 있는지 확인
					if let cached = await self.cacheService.getCacheResults(type: .category, query: category, page: 1) {
						// 1-1. 있으면 cached의 값 리턴
						return (category, cached.books)
					}
					
					// 1-2. 없으면 api 호출
					do {
						let bookResponse = try await self.kakaoService.searchBooks(query: category)
						let booksInfo = bookResponse.documents
						let meta = bookResponse.meta
						let books = booksInfo.map {
							Book(
								title: $0.title,
								authors: $0.authors,
								price: $0.salePrice,
								isbn: $0.isbn,
								thumbnailUrlString: $0.thumbnailUrlString,
								contents: $0.contents
							)
						}
						// 2. categoryCache 데이터에 추가
						await self.cacheService.saveToCache(
							type: .category,
							query: category,
							page: 1,
							books: books,
							totalCount: meta.totalCount,
							isEnd: meta.isEnd
						)
						return (category, books)
						
					} catch let error as NetworkError {
						switch error {
						case .invalidURL:
							await MainActor.run {
								self.errMessage = "URL 오류"
							}
						case .invalidResponse:
							await MainActor.run {
								self.errMessage = "서버 응답 오류"
							}
						case .parsingError:
							await MainActor.run {
								self.errMessage = "데이터 파싱 오류"
							}
						case .networkError:
							await MainActor.run {
								self.errMessage = "네트워크 오류"
							}
						}
					} catch {
						fatalError("알 수 없는 에러: \(error.localizedDescription)")
					}
					return (category, nil)
				}
			}
			
			for await result in group {
				categoryBooks[result.0] = result.1
			}
		}
		isLoadingCategoryStates = false
	}
	
}
