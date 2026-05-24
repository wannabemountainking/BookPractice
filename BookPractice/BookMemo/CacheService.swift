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
	
	// cache에서 뒤지고 없으면 nil 던지는 메서드
	func getDataFromCache(searchingText: String) -> CacheEntry? {
		return cache[searchingText]
	}
	
	// 찾은 단어로 얻은 결과를 cache에 저장하는 메서드
	func saveBooksToCache(searchingText: String, books: [Book]) async {
		// 1. 검색어가 cache에 있을 때
		if var existing = self.cache[searchingText] {
			// a. cache에 저장된 데이터가 60초가 지난 경우 -> cache에서 해당데이터를 지운다. 새로운 값을 넣는다
			if await existing.isExpired {
				cache[searchingText] = nil
				cache[searchingText] = CacheEntry(books: books, savedAt: Date())
				// b. cache에 저장된 데이터가 60초가 안지난 경우 -> 기존 데이터를 유지한다.
			} else {
				cache[searchingText] = existing
			}
			// 2. 검색어가 cache에 없을 때
		} else {
			cache[searchingText] = CacheEntry(books: books, savedAt: Date())
		}
	}
}
