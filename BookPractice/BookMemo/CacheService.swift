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
	
	// mockList를 가져오고 여기서 String이 title, authors에 포함되어 있으면 result: [CacheEntry]에 담아서 saveBooksToCache해서 cache에 담고 값 리턴하기
	func searchBooks(text: String) -> CacheEntry {
		
		return [:]
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
