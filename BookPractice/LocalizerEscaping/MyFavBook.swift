//
//  MyFavBook.swift
//  BookPractice
//
//  Created by YoonieMac on 6/4/26.
//

import Foundation
import SwiftData


@Model
final class MyFavBook {
	var title: String
	var authors: [String]
	var price: Int
	var isbn: String
	var thumbnailUrlString: String
	var contents: String
	var dateAdded: Date
	
	init(title: String, authors: [String], price: Int, isbn: String, thumbnailUrlString: String, contents: String) {
		self.title = title
		self.authors = authors
		self.price = price
		self.isbn = isbn
		self.thumbnailUrlString = thumbnailUrlString
		self.contents = contents
		self.dateAdded = Date()
	}
	
	convenience init(from book: Book) {
		self.init(
			title: book.title,
			authors: book.authors,
			price: book.price,
			isbn: book.isbn,
			thumbnailUrlString: book.thumbnailUrlString,
			contents: book.contents
		)
	}
}

// 확장: text 반영하기
extension MyFavBook {
	var authorsText: String {
		self.authors.joined(separator: ", ")
	}
	var priceText: String {
		self.price.priceText
	}
	
	var thumbnailURL: URL? {
		URL(string: self.thumbnailUrlString)
	}
}

// 확장: MyFavBook -> Book 변환
extension MyFavBook {
	var asBook: Book {
		Book(
			title: self.title,
			authors: self.authors,
			price: self.price,
			isbn: self.isbn,
			thumbnailUrlString: self.thumbnailUrlString,
			contents: self.contents
		)
	}
}
