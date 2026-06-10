import UIKit


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
    guard !currentQuery.isEmpty && hasMorePage && !isLoading && !books.isEmpty else {return}
    
    isLoading = true
    let nextPage = currentPage + 1
    
    defer {
        currentPage = nextPage
        isLoading = false
    }
    
    if let cached = cacheEntry[currentQuery] {
        if Date().timeIntervalSince(cached.savedAt) <= 3 {
            if var existing = cacheEntry[currentQuery] {
                existing.books.append(contentsOf: cached.books)
                cacheEntry[currentQuery] = existing
                books.append(contentsOf: cached.books)
                return
            }
        }
    }
    
    let booksResult = await fakeAPI(query: currentQuery, page: nextPage)
    hasMorePage = !booksResult.isEnd
    books.append(contentsOf: booksResult.books)
    if var existing = cacheEntry[currentQuery] {
        existing.books.append(contentsOf: books)
        cacheEntry[currentQuery] = existing
    } else {
        cacheEntry[currentQuery] = CacheEntry(books: booksResult.books)
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
    
    if let cached = cacheEntry[query] {
        if Date().timeIntervalSince(cached.savedAt) <= 3 {
            cacheEntry[query] = cached
            books = cached.books
            return
        }
    }
    
    let booksResult = await fakeAPI(query: query, page: 1)
    books = booksResult.books
    cacheEntry[query] = CacheEntry(books: books)
}

Task {
    await search(query: "Swift")
    print("검색 결과: \(books)")
    
    await loadMore()
    print("1번 더보기: \(books.count)권")
    
    await loadMore()
    print("2번 더보기: \(books.count)권")
    
    await loadMore()  // 마지막 페이지 이후
    print("3번 더보기: \(books.count)권")
}
