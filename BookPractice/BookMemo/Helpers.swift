//
//  Helpers.swift
//  BookPractice
//
//  Created by YoonieMac on 5/24/26.
//

import Foundation


struct Book: Identifiable {
	let title: String
	let authors: [String]
	let rating: Double
	let price: Int
	let isbn: String
}

extension Book {
	
	var id: String { "\(title)_\(isbn)_" }
	var ratingText: String { "평점: ⭐️ \(rating) " }
	var priceText: String { "\(price.formatted())원" }
	var authorsText: String { "\(authors.joined(separator: ", "))" }
}

struct CacheEntry {
	var books: [Book]
	let savedAt: Date
	
	var isExpired: Bool { Date().timeIntervalSince(savedAt) > 60 }
}

enum SortOption {
	case ratingDesc, ratingAsc
	case priceDesc, priceAsc
	case titleAsc
}


