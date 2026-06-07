//
//  SearchView.swift
//  BookPractice
//
//  Created by yoonie on 6/7/26.
//

import SwiftUI

struct SearchView: View {
    
    @State private var searchVM = SearchBookViewModel()
    @State private var searchText: String = ""
    @State private var selectedBook: Book?
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.yellow.opacity(0.1).ignoresSafeArea()
				
				VStack(spacing: 20) {
					textFieldView
					
					HStack(spacing: 30) {
						Text(searchVM.currentQuery)
						Text("총 \(searchVM.searchedBooks.count)권")
						Spacer()
					}
					
					if !searchVM.hasSearched {  // 아직 검색 안함
						searchGuideView
					} else if searchVM.isloading {  // 검색은 했는데 아직 검색중
						ProgressView("검색 중...")
					} else if searchVM.searchedBooks.isEmpty { // 검색은 했고 검색중도 아닌데 결과가 없음
						noResultView
					} else {             // 검색은 했고, 검색중도 아니며 결과는 있음
						bookResultView
					}
				}
				.onAppear {
					isSearchFocused = true
				}
                
            }
        }
    }
}

extension SearchView {
    @ViewBuilder
    private var textFieldView: some View {
        VStack {
            HStack {
                TextField("검색할 책을 입력하세요", text: $searchText)
					.focused($isSearchFocused)
					.textFieldStyle(.roundedBorder)
					.submitLabel(.search)
					.onSubmit {
						Task {
							await searchVM.searchBooks(query: searchText)
						}
					}
				
				Button {
					// action
					searchText = ""
					isSearchFocused = false
				} label: {
					Image(systemName: "xmark.circle.fill")
						.foregroundStyle(Color.gray.opacity(0.7))
				}
				.buttonStyle(.plain)

				
                Button("검색") {
					isSearchFocused = false
                    Task {
                        await searchVM.searchBooks(query: searchText)
                    }
                }
            }
        }
		.padding()
    }
	
	@ViewBuilder
	private var searchGuideView: some View {
		ContentUnavailableView(
			"검색을 해 주세요",
			systemImage: "books.vertical",
			description: Text("검색창에 찾고 싶은 책이나 저자를 검색해 보세요")
		)
		.foregroundStyle(.orange.opacity(0.8))
	}
	
	@ViewBuilder
	private var noResultView: some View {
		ContentUnavailableView(
			"검색 결과 없음",
			systemImage: "books.vertical",
			description: Text("\(searchVM.currentQuery)의 검색 결과가 없습니다. 다시 검색해 주세요")
		)
		.foregroundStyle(.brown.opacity(0.8))
	}
	
	@ViewBuilder
	private var bookResultView: some View {
		ScrollView {
			LazyVGrid(
				columns: [
					GridItem(.flexible(), spacing: 20),
					GridItem(.flexible(), spacing: 20),
					GridItem(.flexible(), spacing: 20)
				],
				alignment: .center,
				spacing: 20,
				pinnedViews: [.sectionHeaders],
				content: {
					ForEach(searchVM.searchedBooks, id: \.id) { book in
						ZStack {
							Color.pink.opacity(0.2)
							
							VStack {
								Text(book.title)
								Text(book.priceText)
								Text(book.authorsText)
							}
							.font(.caption)
						}
						.frame(width: 120, height: 180)
						.task {
							let current = searchVM.searchedBooks
							if let index = current.firstIndex(where: { $0.id == book.id }),
							   index >= current.count - 3 {
								await searchVM.loadMoreBooks()
							}
						}
					}
				}
			)
		}
		.padding()
	}
}

#Preview {
    SearchView()
}
