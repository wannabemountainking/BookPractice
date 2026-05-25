//
//  Helpers.swift
//  BookPractice
//
//  Created by YoonieMac on 5/24/26.
//

import Foundation

nonisolated
struct BookResponse: Codable {
	let documents: [BookInfo]
	let meta: BookMeta
	
	struct BookInfo: Codable {
		let title: String
		let authors: [String]
		let salePrice: Int
		let isbn: String
		let thumbnailUrlString: String
		let contents: String
		
		enum CodingKeys: String, CodingKey {
			case title, authors
			case salePrice = "sale_price"
			case isbn
			case thumbnailUrlString = "thumbnail"
			case contents
		}
	}
	
	struct BookMeta: Codable {
		var isEnd: Bool
		var totalCount: Int
		
		enum CodingKeys: String, CodingKey {
			case isEnd = "is_end"
			case totalCount = "total_count"
		}
	}
}

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
	let price: Int
	let isbn: String
	let thumbnailUrlString: String
	let contents: String
	var isEnd: Bool
	var totalCount: Int
}

extension Book {
	var id: String { "\(title)_\(isbn)_" }
	var priceText: String { price.priceText }
	var authorsText: String { "\(authors.joined(separator: ", "))" }
	var isbnText: String { "ISBN: \(isbn)" }
}

struct CacheEntry: Sendable {
	var books: [Book]
	let savedAt: Date
	
	nonisolated var isExpired: Bool {
		return Date().timeIntervalSince(savedAt) > 60
	}
}

enum SortOption {
	case priceDesc, priceAsc
	case titleAsc
}

enum BookError: Error {
	case invalidResponse
	case invalidURL
}

