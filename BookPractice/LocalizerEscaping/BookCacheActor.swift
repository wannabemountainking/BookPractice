//
//  BookCacheActor.swift
//  BookPractice
//
//  Created by YoonieMac on 6/1/26.
//

import Foundation

// query에 대한 검색결과와 metaData를 담는 구조체
struct CacheResult {
	let books: [Book]   // 검색 결과
	let totalCount: Int // 전체 책 수
	let isEnd: Bool     // 마지막 페이지 인지 여부
	let timeStamp: Date  // cache 저장 시간
}



actor BookCacheActor {
	
	enum CacheType: Equatable {
		case search  // searchResultDict 에 저장
		case category // categoryResultDict 에 저장

		var description: String {
			switch self {
			case .search: return "search"
			case .category: return "category"
			}
		}
		static func == (lhs: CacheType, rhs: CacheType) -> Bool {
			return lhs.description == rhs.description
		}
	}
	
	static let shared = BookCacheActor()
	
	// 상태 변수
	private var searchResultsDict: [String: CacheResult] = [:]
	private var categoryResultsDict: [String: CacheResult] = [:]
	private var cacheExpiration: TimeInterval = 60
	
	private init() {}
	
	func getCacheResults(type: CacheType, query: String, page: Int) -> CacheResult? {
		// 1. key 설정
		let key = "\(query)_\(page)"
		
		// 2. cache hit 확인
		let dict = (type == .search) ? searchResultsDict : categoryResultsDict
		guard let cached = dict[key] else { return nil } // vm에서 처리
		
		// 3. hit일 때 유효시간이 지났는지
		let timeAfterSaved = Date().timeIntervalSince(cached.timeStamp)
		guard cacheExpiration >= timeAfterSaved else { return nil } // vm에서 처리
		
		// 4. 저장할 자료 return
		return cached
	}
	
	func saveToCache(type: CacheType, query: String, page: Int, books: [Book], totalCount: Int, isEnd: Bool) {
		
		let key = "\(query)_\(page)"
		let cacheResult = CacheResult(
			books: books,
			totalCount: totalCount,
			isEnd: isEnd,
			timeStamp: Date()
		)
		switch type {
		case .search:
			searchResultsDict[key] = cacheResult
		case .category:
			categoryResultsDict[key] = cacheResult
		}
	}
}
