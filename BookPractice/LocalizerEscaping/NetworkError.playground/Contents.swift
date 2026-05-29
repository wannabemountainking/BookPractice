import UIKit
import SwiftData

//enum NetworkError: Error, LocalizedError {
//	case serverError
//	case noInternetConnection
//	
//	var errorDescription: String? {
//		switch self {
//		case .serverError: return "서버 오류"
//		case .noInternetConnection: return "인터넷 연결 오류"
//		}
//	}
//	
//	var recoverySuggestion: String? {
//		switch self {
//		case .serverError: return "해당 서버에 문의하세요"
//		case .noInternetConnection: return "wifi나 lte상태 또는 공유기를 점검하세요"
//		}
//	}
//}
//
//func fetchData() throws {
//	if Int.random(in: 1...10).isMultiple(of: 2) {
//		throw NetworkError.serverError
//	} else {
//		throw NetworkError.noInternetConnection
//	}
//}
//
//func runData() {
//	do {
//		try fetchData()
//	} catch let err as NetworkError {
//		print(err.errorDescription ?? "문제를 모르겠어요")
//		print(err.recoverySuggestion ?? "고칠 방법이 없어요")
//	} catch {
//		print(error.localizedDescription)
//	}
//}
//runData()

//struct BookMeta: Codable {
//	let totalCount: Int
//	let pageableCount: Int
//	let isEnd: Bool
//	
//	enum CodingKeys: String, CodingKey {
//		case totalCount = "total_count"
//		case pageableCount = "pageable_count"
//		case isEnd = "is_end"
//	}
//	
//	// 여기에 두 개 추가해봐
//	var isLastPage: Bool { self.isEnd }
////	var totalPages: Int { self.pageableCount / size + 1}
//	func getTotalPages(size: Int) -> Int {
//		var numberOfPages = self.pageableCount / size
//		return (self.pageableCount % size == 0) ? numberOfPages : numberOfPages + 1
//	}
//}

//API 응답모델

struct Memo: Identifiable, Codable {
	let id: String
	let title: String
	let body: String
	let createdAt: String
	
	enum CodingKeys: String, CodingKey {
		case id, title, body
		case createdAt = "created_at"
	}
}

// SwiftData 저장 모델
//@Model
final class SavedMemo: Identifiable {
	var id: String
	var title: String
	var body: String
	var createdAt: String
	var isPinned: Bool
	var localCreatedAt: Date
	
	init(id: String, title: String, body: String, createdAt: String) {
		self.id = id
		self.title = title
		self.body = body
		self.createdAt = createdAt
		self.isPinned = false
		
		self.localCreatedAt = {
			let formatter = DateFormatter()
			formatter.dateFormat = "yyyy-MM-dd"
			return formatter.date(from: createdAt) ?? Date()
		}()
	}
	
	convenience init(from memo: Memo) {
		self.init(
			id: memo.id,
			title: memo.title,
			body: memo.body,
			createdAt: memo.createdAt
		)
	}
	
	var asMemo: Memo {
		return Memo(
			id: self.id,
			title: self.title,
			body: self.body,
			createdAt: self.createdAt
		)
	}
}



let memo = Memo(
	id: "memo_001",
	title: "Swift 공부",
	body: "convenience init 배움",
	createdAt: "2026-01-19"
)

let savedMemo = SavedMemo(from: memo)

print(savedMemo.isPinned)
print(savedMemo.localCreatedAt)
print(savedMemo.asMemo)
