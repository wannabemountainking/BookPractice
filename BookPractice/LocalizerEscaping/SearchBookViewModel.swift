//
//  SearchBookViewModel.swift
//  BookPractice
//
//  Created by yoonie on 6/4/26.
//

import Foundation
import Observation


@MainActor
@Observable
final class SearchBookViewModel {
    
    // properties: 1. cache와 network 싱글톤 서비스
    let cacheService = BookCacheActor.shared
    let kakaoService = KakaoService.shared
    
    // properties: 2. SEARCHRESULTS와 각 상태를 담은 변수
    var searchedBooks: [Book] = []
    var isloading: Bool = false
    var currentPage: Int = 1
    var hasMorePage: Bool = true
    var currentQuery: String = ""
    var errorMessage: String?
    
    func searchBooks(query: String, size: Int = 40) async {
        // 1. 초기화
        isloading = true
        searchedBooks = []
		currentQuery = query
        errorMessage = nil
        
        defer {
            currentPage = 1
            isloading = false
        }
        
        // 2. cache에 저장되어 있는 것인지 확인하고 있으면 바로 리턴
        if let cached = await cacheService.getCacheResults(type: .search, query: query, page: 1) {
            searchedBooks = cached.books
            return
        }
        
        // 3. cached에 없으면 kakao에서 받아오기
        do {
            let books = try await fetchBooks(query: query)
            searchedBooks = books
            
        } catch {
            handleError(error)
        }
    }
    
    func loadMoreBooks() async {
        // 1. 상태 초기화
        guard hasMorePage && !isloading else { return }
        isloading = true
        let nextPage = currentPage + 1
        
        // 2. 마지막에 해야 할 일
        defer {
            currentPage = nextPage
            isloading = false
        }
        
        // 3. cached에 있는지 확인 있으면 바로 가져옴
        if let cached = await cacheService.getCacheResults(type: .search, query: currentQuery, page: nextPage) {
            searchedBooks.append(contentsOf: cached.books)
            return
        }
        
        // 4. cached에 없으므로 kakao 호출
        do {
            let newBooks = try await fetchBooks(query: currentQuery, page: nextPage)
            searchedBooks.append(contentsOf: newBooks)
        } catch {
            handleError(error)
        }
    }
    
    private func fetchBooks(query: String, page: Int = 1) async throws -> [Book] {
		let bookResponse = try await kakaoService.searchBooks(query: query, page: page)
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
		await cacheService.saveToCache(
			type: .search,
			query: currentQuery,
			page: page,
			books: newBooks,
			totalCount: meta.totalCount,
			isEnd: meta.isEnd
		)
		hasMorePage = !meta.isEnd
		return newBooks
    }
    
    private func handleError(_ error: Error) {
        if let err = error as? NetworkError {
            switch err {
            case .invalidURL:
                errorMessage = "URL 에러"
            case .invalidResponse:
                errorMessage = "서버 응답 에러"
            case .parsingError:
                errorMessage = "데이터 파싱 에러"
            case .networkError:
                errorMessage = "네트워크 에러"
            }
        }
    }
}
