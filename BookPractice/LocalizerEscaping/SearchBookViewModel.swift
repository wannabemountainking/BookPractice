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
        currentPage = 1
        currentQuery = query
        errorMessage = nil
        
        defer {
            isloading = false
        }
        
        // 2. cache에 저장되어 있는 것인지 확인하고 있으면 바로 리턴
        if let cacheResult = await cacheService.getCacheResults(type: .search, query: query, page: 1) {
            searchedBooks = cacheResult.books
            return
        }
        
        
        
    }
}
