import UIKit
//import Observation

struct CacheEntry {
	var books: [String]
	let savedAt: Date = Date()
}

var cacheEntry: [String: CacheEntry] = [:]

var currentPage: Int = 1
var hasMorePage: Bool = true
var isLoading: Bool = false
var currentQuery: String = ""
var books: [String] = []

// 더미 API
func fakeAPI(query: String, page: Int) async -> (books: [String], isEnd: Bool) {
    try? await Task.sleep(for: .seconds(1))
    let books = (1...5).map { "\(query) \(page)페이지 책\($0)" }
    let isEnd = page >= 3  // 3페이지가 마지막
    return (books, isEnd)
}

@MainActor
func loadMore() async {
    // 0. query값이 비어있으면 그냥 중단
    // 1. 상태 초기화(currentPage = 1, .,.), nextPage 설정
    // 2. 마지막에 반드시 해야하는 상태 확인 (defer{  currentPage += 1 ...})
    // 3. cache에 저장되어 있고 3초가 안지난 데이타면 바로 books에
    // 4. 3.의 경우가 아니면 API호출
    // 5. 4로 호출 값으로 books == 호출 값
    // 6. 추출된 books를 cache에 저장
	print("guard 진입, hasMorePage: \(hasMorePage)")
    guard !currentQuery.isEmpty && hasMorePage && !isLoading && !books.isEmpty else {return}
    print(hasMorePage)
    isLoading = true
    let nextPage = currentPage + 1
    let cacheKey = "\(currentQuery)_page\(nextPage)"
	
    defer {
        currentPage = nextPage
        isLoading = false
    }
    
    if let cached = cacheEntry[cacheKey] {
        if Date().timeIntervalSince(cached.savedAt) <= 3 {
			books.append(contentsOf: cached.books)
			return
        }
    }
    
    let booksResult = await fakeAPI(query: currentQuery, page: nextPage)
    hasMorePage = !booksResult.isEnd
    books.append(contentsOf: booksResult.books)
    if var existing = cacheEntry[cacheKey] {
		existing.books.append(contentsOf: booksResult.books)
        cacheEntry[cacheKey] = existing
    } else {
        cacheEntry[cacheKey] = CacheEntry(books: booksResult.books)
    }
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
    guard !query.isEmpty else {return}
    isLoading = true
    currentPage = 1
    currentQuery = query
	
    defer {
        isLoading = false
    }
    
	print("캐시 키들: \(cacheEntry.keys)")
    if let cached = cacheEntry["\(currentQuery)_page1"] {
        if Date().timeIntervalSince(cached.savedAt) <= 3 {
			cacheEntry["\(currentQuery)_page1"] = cached
            books = cached.books
            return
        }
    }
    
    let booksResult = await fakeAPI(query: query, page: 1)
    books = booksResult.books
    cacheEntry["\(currentQuery)_page1"] = CacheEntry(books: books)
}

//Task {
//	await search(query: "Swift")
//	print("검색 결과: \(books)")
//
//	await loadMore()
//	//    print("1번 더보기: \(books.count)권")
//	print(books)
//
//	await loadMore()
//	//    print("2번 더보기: \(books.count)권")
//	print(books)
//
//	await loadMore()  // 마지막 페이지 이후
//	//    print("3번 더보기: \(books.count)권")
//	print(books)
//
//	await search(query: "Swift")
//	print("두번째 검색: \(books.count)권")
//	await search(query: "Swift")
//	print("3번째 검색: \(books.count)권")
//	await search(query: "Swift")
//}

//final class MyMyBook {
//    var isbn: String
//    var title: String
//    
//    init(isbn: String, title: String) {
//        self.isbn = isbn
//        self.title = title
//    }
//}
//
//struct MyFavBook {
//	let isbn: String
//    let title: String
//}
//
//var myFavBooks: [MyFavBook] = []
//
//@MainActor
//func isBookmarked(book: MyMyBook) -> Bool {
//	myFavBooks.contains(where: { $0.isbn == book.isbn })
//}
//
//@MainActor
//func toggleBookmark(book: MyMyBook) {
//	if isBookmarked(book: book) {
//		guard let index = myFavBooks.firstIndex(where: { $0.isbn == book.isbn }) else { return }
//		myFavBooks.remove(at: index)
//	} else {
//        myFavBooks.append(MyFavBook(isbn: book.isbn, title: book.title))
//	}
//}
//
//let book1 = MyMyBook(isbn: "001", title: "Swift 프로그래밍")
//let book2 = MyMyBook(isbn: "002", title: "SwiftUI 완벽 가이드")
//
//// 테스트
//Task {
//    print("book1 북마크 상태: \(isBookmarked(book: book1))")
//    toggleBookmark(book: book1)
//    print("book1 추가 후: \(myFavBooks.map { $0.isbn })")
//    toggleBookmark(book: book1)
//    print("book1 제거 후: \(myFavBooks.map { $0.isbn })")
//    toggleBookmark(book: book2)
//    toggleBookmark(book: book1)
//    print("최종: \(myFavBooks.map { $0.isbn })")
//}

//@Observable
//class ViewModel {
//    var bookmarks: [String] = []
//    
//    func toggle(isbn: String) {
//        if bookmarks.contains(isbn) {
//            bookmarks.removeAll { $0 == isbn }
//        } else {
//            bookmarks.append(isbn)
//        }
//    }
//}
//
//struct TestView: View {
//    @State private var vm = ViewModel()
//    let isbn = "001"
//    
//    // isBookmarked 계산 프로퍼티
//    private var isBookmarked: Bool {
//        vm.bookmarks.contains(isbn)
//    }
//    
//    var body: some View {
//        Button(isBookmarked ? "북마크 해제" : "북마크") {
//            vm.toggle(isbn: isbn)
//        }
//    }
//}

func makeButton(onTapped: (String) -> Void) {
    onTapped("책1")
}

makeButton { book in
    print("탭된 책: \(book)")
}

var isSearching: Bool = false
var wasSearched: Bool = false
var resultBooks: [String] = []


if isSearching {
    print("검색 중")
} else if !wasSearched {
    print("검색 전")
} else if resultBooks.isEmpty {
    print("검색 결과 없음")
} else {
    print("검색 결과 있음")
}


