//
//  BookDemoView.swift
//  BookPractice
//
//  Created by yoonie on 5/25/26.
//

import SwiftUI

struct BookDemoView: View {
    @State private var vm: BookDemoViewModel = .init()
    @State private var queryText: String = ""
	@State private var isPriceAsc: Bool = true
	@State private var hasErrorMessage: Bool = false
    
    var body: some View {
        NavigationStack {
			HStack {
				Text("검색")
					.font(.title3)
				TextField("책이나 작가명을 입력하세요", text: $queryText)
					.font(.title3)
					.textFieldStyle(.roundedBorder)
					.padding()
				Button {
					//action
					if !queryText.isEmpty {
						Task {
							await vm.searchBooks(text: queryText)
							self.hasErrorMessage = (vm.errorMessage != nil)
						}
					}
				} label: {
					Image(systemName: "magnifyingglass")
						.font(.title2)
						.fontWeight(.heavy)
						.foregroundStyle(queryText.isEmpty ? Color.gray : Color.blue)
						.disabled(queryText.isEmpty)
				}
				.buttonStyle(.plain)
			} //:HSTACK
			.padding(.horizontal, 20)
			
			
			if vm.isLoading {
				Spacer()
				ProgressView("검색 중...")
					.scaleEffect(1.5)
				Spacer()
			} else {
				ScrollView(.vertical) {
					LazyVStack {
						ForEach(vm.currentBooks, id: \.id) { book in
							RoundedRectangle(cornerRadius: 10)
								.frame(maxWidth: .infinity)
								.frame(height: 100)
								.foregroundStyle(Color.orange.opacity(0.2))
								.overlay(content: {
									self.subView(book: book)
								})
								.padding()
						} //:LOOP
					} //:VSTACK
				} //:SCROLL
				.navigationTitle("My Books")
				.toolbar {
					ToolbarItem(placement: .topBarTrailing) {
						VStack {
							Button("price", systemImage: self.isPriceAsc ? "arrow.up" : "arrow.down") {
								
								if self.isPriceAsc {
									self.vm.sortOptions(option: .priceAsc)
								} else {
									self.vm.sortOptions(option: .priceDesc)
								}
								self.isPriceAsc.toggle()
							}
							.buttonStyle(.plain)
							
							Text("가격순")
								.font(.caption)
						}
					}
				} //:TOOLBAR
				.alert("확인", isPresented: $hasErrorMessage) {
					//action
				} message: {
					Text("에러 발생: \(String(describing: self.vm.errorMessage))")
				}

			}//:CONDITIONAL
        } //:NAVIGATION

    }//:body
	
	private func subView(book: Book) -> some View {
		VStack {
			HStack {
				Text(book.title)
					.fontWeight(.bold)
				Spacer()
				Text(book.authorsText)
			}
			HStack {
				Spacer()
				Text(book.priceText)
			}
			HStack {
				Spacer()
				Text(book.isbnText)
					.font(.subheadline)
			}
		}
		.font(.title3)
		.padding(20)
	}
}

#Preview {
    BookDemoView()
}
