//
//  MyLibraryViewModel.swift
//  BookPractice
//
//  Created by YoonieMac on 6/4/26.
//

import Foundation
import SwiftData
import Observation


@MainActor
@Observable
final class MyLibraryViewModel {
	// properties: modelContext, myFavBooks, isLoading, errorMessge
	private var modelContext: ModelContext?
	private(set) var myFavBooks: [MyFavBook] = []
	private(set) var isLoading: Bool = false
	private(set) var errorMessage: String?
	
	func setModelContext(context: ModelContext) {
		self.modelContext = context
		self.loadMyBooks()
	}
	
	// CRUD
	
	// Read. loadMyBooks
	func loadMyBooks() {
		// 1. modelContext가 있는지 nil이면 걍 끝. 초기화
		guard let modelContext else { return }
		isLoading = true
		errorMessage = nil
		
		// 2. dateAdded 역순으로 정렬한 FetchedDescriptor
		let descriptor = FetchDescriptor<MyFavBook>(sortBy: [SortDescriptor(\.dateAdded, order: .reverse)])
		
		// 3. 이 FetchedDescriptor로 책 가져오기
		do {
			myFavBooks = try modelContext.fetch(descriptor)
		} catch {
			errorMessage = "책 목록을 가져오는데 실패했습니다: \(error.localizedDescription)"
		}
		
		// 원상 복귀
		isLoading = false
	}
	
	// Create. addMyBook
	func addMyBook(book: Book) {
		// 1. modelContext 가 없으면 걍 끝, isLoading 설정
		guard let modelContext else { return }
		isLoading = true
		
		// 2. Book -> MyFavBook 으로 바꾸기
		let myBook = MyFavBook(from: book)
		modelContext.insert(myBook)
		// 3. MyFavBook을 Context에 저장하기
		do {
			try modelContext.save()
			loadMyBooks()
		} catch {
			errorMessage = "책 목록에 추가하지 못했습니다: \(error.localizedDescription)"
		}
		
		// 원상태 복귀
		isLoading = false
	}
	
	// Delete. removeBook
	func removeMyBook(book: Book) {
		// 1. modelContext 가 nil 이면 리턴, 초기값 세팅
		guard let modelContext else {return}
		isLoading = true
		
		// 2. descriptor 조건(isbn이 동일한 책) 으로 지울 책 찾기
		let descriptor = FetchDescriptor<MyFavBook>(predicate: #Predicate {
			$0.isbn == book.isbn
		})
		
		// 3. 책을 찾아 지운다 SwiftData에서 지우고 modelContext도 저장한다.
		do {
			guard let myBook = try modelContext.fetch(descriptor).first else {
				isLoading = false
				errorMessage = "목록에 해당 책이 없습니다"
				return
			}
			modelContext.delete(myBook)
			try modelContext.save()
			loadMyBooks()
		} catch {
			errorMessage = "목록에서 책을 삭제하지 못했습니다: \(error.localizedDescription)"
		}
		
		isLoading = false
	}
}

// bookMark관련 메서드
extension MyLibraryViewModel {
	func isBookmarked(book: Book) -> Bool {
		myFavBooks.contains(where: { $0.isbn == book.isbn })
	}
	
	func toggleBookmark(book: Book) {
		if isBookmarked(book: book) {
			removeMyBook(book: book)
		} else {
			addMyBook(book: book)
		}
	}
}

