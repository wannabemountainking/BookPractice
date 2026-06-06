//
//  MyDenViewModel.swift
//  BookPractice
//
//  Created by YoonieMac on 6/4/26.
//

import SwiftUI
import SwiftData

struct MyDenView: View {
	
	@Environment(\.modelContext) private var modelContext
	
	@State private var myDenVM = MyDenViewModel()
	@State private var searchVM = SearchBookViewModel()
	@State private var searchText: String = ""
	@State private var bookToDelete: MyFavBook?
	@State private var willBeDeleted: Bool = false
	@Query private var myFavoriteBooks: [MyFavBook]
	
    var body: some View {
		VStack {
			searchView
			Divider()
			ScrollView(.vertical) {
				myFavBooksView
			}
		}
		.alert(
			"내 영화 목록에서 삭제",
			isPresented: $willBeDeleted,
			actions: {
				Button("삭제") {
					guard let bookToDelete else {return}
					myDenVM.deleteMyFavBook(book: bookToDelete)
					willBeDeleted = false
				}
				Button("취소") {
					willBeDeleted = false
				}
			},
			message: {
				if let bookToDelete {
					Text(
						"내 영화 목록에서 ⎡\(bookToDelete.title)⎦ 을(를) 삭제하시겠습니까?"
					)
				}
			}
		)
		.onAppear {
			myDenVM.setModelContext(context: modelContext)
		}
    }
	
	private var searchView: some View {
		VStack {
			HStack {
				TextField("책 검색", text: $searchText)
					.textFieldStyle(.roundedBorder)
				Button("검색") {
					Task {
						await searchVM.searchBooks(query: searchText, size: 20)
					}
				}
			}
			
			ScrollView(.horizontal) {
				LazyHStack {
					ForEach(searchVM.searchedBooks, id: \.id) { book in
						RoundedRectangle(cornerRadius: 10)
							.fill(Color.white)
							.frame(width: 150, height: 220)
							.overlay {
								VStack {
									Text(book.title)
									Text(book.priceText)
								}
								.font(.caption2).bold()
								.background(Color.white.opacity(0.6))
							}
							.border(.yellow, width: 2)
							.onTapGesture {
								myDenVM.addMyBook(book: book)
							}
					}
				}
			}
		}
	}
	
	@ViewBuilder
	private var myFavBooksView: some View {
		LazyVGrid(
			columns: [
				GridItem(.flexible(), spacing: 20),
				GridItem(.flexible(), spacing: 20),
				GridItem(.flexible(), spacing: 20),
			],
			spacing: 20,
			content: {
				ForEach(myFavoriteBooks, id: \.id) { book in
					RoundedRectangle(cornerRadius: 10)
						.fill(Color.white)
						.frame(width: 100, height: 150)
						.overlay {
							bookCard(book)
						}
						.buttonStyle(.plain)
				}
			}
		)
	}
	
	@ViewBuilder
	private func bookCard(_ book: MyFavBook) -> some View {
		VStack {
			Text(book.title)
			Text(book.priceText)
		}
		.font(.caption2).bold()
		.background(Color.white.opacity(0.6))
		.onLongPressGesture {
			bookToDelete = book
			willBeDeleted = true
		}
	}
}

#Preview {
    MyDenView()
		.modelContainer(for: MyFavBook.self, inMemory: true)
}
