//
//  Helpers.swift
//  BookPractice
//
//  Created by YoonieMac on 5/24/26.
//

import Foundation

extension Int {
	var priceText: String {
		let f = NumberFormatter()
		f.numberStyle = .decimal
		return "\(f.string(from: NSNumber(value: self)) ?? "\(self)")원"
	}
}

struct Book: Identifiable, Sendable {
	let title: String
	let authors: [String]
	let rating: Double
	let price: Int
	let isbn: String
}

extension Book {
	
	var id: String { "\(title)_\(isbn)_" }
//	var ratingText: String { "평점: ⭐️ \(rating) " }
//	var priceText: String { price.priceText }
//	var authorsText: String { "\(authors.joined(separator: ", "))" }
}

extension Book {
	nonisolated static let mockList: [Book] = [
		Book(title: "Swift 프로그래밍", authors: ["Apple"], rating: 4.8, price: 35000, isbn: "9781"),
		Book(title: "클린 코드", authors: ["Robert Martin"], rating: 4.5, price: 28000, isbn: "9782"),
		Book(title: "미움받을 용기", authors: ["기시미 이치로", "고가 후미타케"], rating: 4.7, price: 15000, isbn: "9783"),
		Book(title: "사피엔스", authors: ["유발 하라리"], rating: 4.6, price: 22000, isbn: "9784"),
		Book(title: "채식주의자", authors: ["한강"], rating: 4.3, price: 13000, isbn: "9785"),
		Book(title: "아토믹 해빗", authors: ["제임스 클리어"], rating: 4.9, price: 18000, isbn: "9786"),
		Book(title: "디자인 패턴", authors: ["GoF"], rating: 4.2, price: 42000, isbn: "9787"),
		Book(title: "1984", authors: ["조지 오웰"], rating: 4.4, price: 11000, isbn: "9788"),
		Book(title: "린 스타트업", authors: ["에릭 리스"], rating: 4.1, price: 19000, isbn: "9789"),
		Book(title: "해리포터", authors: ["J.K. 롤링"], rating: 4.8, price: 16000, isbn: "9790"),
		Book(title: "코스모스", authors: ["칼 세이건"], rating: 4.7, price: 24000, isbn: "9791"),
		Book(title: "팩트풀니스", authors: ["한스 로슬링"], rating: 4.5, price: 17000, isbn: "9792")
	]
}

struct CacheEntry: Sendable {
	var books: [Book]
	let savedAt: Date
	
	nonisolated var isExpired: Bool {
		return Date().timeIntervalSince(savedAt) > 60
	}
}

enum SortOption {
	case ratingDesc, ratingAsc
	case priceDesc, priceAsc
	case titleAsc
}


