import UIKit

// TTL
//struct CacheEntry {
//	let books: [String]
//	let savedAt: Date = Date()
//	
//}
//
//
//
//// API 호출 대신 이걸 쓰자
//func fakeAPICall(query: String) async -> [String] {
//	try? await Task.sleep(for: .seconds(1))  // 네트워크 지연 시뮬레이션
//	return ["\(query) 책1", "\(query) 책2", "\(query) 책3"]
//}
//
//var fakeCache: [String: CacheEntry] = [:]
//
//@MainActor
//func fetchBooks(query: String) async -> [String] {
//	
//	// 1. 캐시 유무 및 캐시 한지 3초 지났는지 여부 확인
//	if let cached = fakeCache[query] {
//		if Date().timeIntervalSince(cached.savedAt) <= 3 {
//			print("cache Hit: \(fakeCache)")
//			return cached.books
//		} else {
//			fakeCache[query] = nil
//		}
//	}
//	   
//	// 3. 캐시에 없거나 있더라도 3초 지난 자료는  API 호출
//	let books = await fakeAPICall(query: query)
//	let cacheEntry = CacheEntry(books: books)
//	// 4. 캐시 저장
//	fakeCache[query] = cacheEntry
//	// 5. 리턴
//	print("API 호출")
//	return cacheEntry.books
//}

//var isLoading: Bool = false
//
//// 더미 API 호출
//func fakeLoadMore() async {
//	try? await Task.sleep(for: .seconds(2))
//	print("데이터 로드 완료")
//}
//
//@MainActor
//func loadMore() async {
//	// 여기 짜봐
//	guard !isLoading else {return}
//	isLoading = true
//	defer {
//		isLoading = false
//	}
//	await fakeLoadMore()
//}
//
//// 테스트: 동시에 3번 호출
//Task { await loadMore() }
//Task { await loadMore() }
//Task { await loadMore() }


//var categoryBooks: [String: [Book]] = [:]
//
//// "Swift" 카테고리에 새 책들을 추가하는 함수
//@MainActor
//func appendBooks(category: String, newBooks: [Book]) {
//	// 여기 짜봐
//	if var existing = categoryBooks[category] {
//		existing.append(contentsOf: newBooks)
//		categoryBooks[category] = existing
//	} else {
//		categoryBooks[category] = newBooks
//	}
//	
//}


var currentPage: Int = 1
var hasMorePage: Bool = true
var currentQuery: String = ""
var isLoading: Bool = false
var books: [String] = []

// 더미 API
func fakeAPI(query: String, page: Int) async -> (books: [String], isEnd: Bool) {
	try? await Task.sleep(for: .seconds(1))
	let books = (1...5).map { "\(query) \(page)페이지 책\($0)" }
	let isEnd = page >= 3  // 3페이지가 마지막
	return (books, isEnd)
}

@MainActor
func search(query: String) async {
	// 0. query값이 비어있으면 그냥 중단
	// 1. 상태 초기화(currentPage = 1, .,.), nextPage 설정
	// 2. 마지막에 반드시 해야하는 상태 확인 (defer{  currentPage += 1 ...})
	// 3. cache에 저장되어 있고 3초가 안지난 데이타면 바로 books에
	// 4. 3.의 경우가 아니면 API호출
	// 5. 4로 호출 값으로 books == 호출 값
	// 6. 추출된 books를 cache에 저장
}


func loadMore() async { }
