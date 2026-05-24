//
//  Cache.swift
//  BookPractice
//
//  Created by YoonieMac on 5/24/26.
//

import Foundation



actor CacheService {
	
	static let shared = CacheService()
	
	var cache: [String: CacheEntry] = [:]
	
	private init() { }
	
	// mockList를 가져오고 여기서 String이 title, authors에 포함되어 있으면 result: [CacheEntry]에 담아서 saveBooksToCache해서 cache에 담고 값 리턴하기 1. cache에서 query의 값을 가져온다(실제적인 SEARCH). 없거나 60초 이후의 자료라면 2. 1초 기다린다 3. mocklist에서 해당 내용을 잡아온다
    func searchBooks(query: String) async throws -> [Book] {
        if let cached = self.getDataFromCache(searchingText: query) {
            return cached.books
        } else {
            do {
                try await Task.sleep(for: .seconds(1))
                let booksSearched: [Book] = Book.mockList.filter { $0.title.contains(query) || $0.authors.contains(where: { $0.contains(query) }) }
                self.saveBooksToCache(searchingText: query, books: booksSearched)
                return booksSearched
            } catch {
                throw BookError.noSearchResult
            }
        }
	}
	
	
	// cache에서 뒤지고 없거나, 이미 오래된 데이터는 nil 있고 최신 데이터면 CacheEntry
    private func getDataFromCache(searchingText: String) -> CacheEntry? {
		guard let cachedData = cache[searchingText],
			  !cachedData.isExpired else { return nil }
		return cachedData
	}
	
	// cache에 저장값이 없거나 이미 오래된 데이터 -> 새 데이터로, 아니면 그냥 놔둠
	private func saveBooksToCache(searchingText: String, books: [Book]) {
		if cache[searchingText] == nil || cache[searchingText]!.isExpired {
			cache[searchingText] = CacheEntry(books: books, savedAt: Date())
		}
	}
}
