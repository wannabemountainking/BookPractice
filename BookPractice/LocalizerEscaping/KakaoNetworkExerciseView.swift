//
//  KakaoNetworkExerciseView.swift
//  BookPractice
//
//  Created by YoonieMac on 5/30/26.
//

import SwiftUI

struct KakaoNetworkExerciseView: View {
	
	@State private var vm: HomeViewModel = .init()
	@State private var query: String = ""
	
    var body: some View {
		ScrollView {
			VStack {
				HStack {
					TextField("책을 찾아라", text: $query)
					Spacer()
					Button {
						//Action
						Task {
							await self.vm.searchBooks(query: query)
						}
					} label: {
						Text("책을 찾아요")
					}
				}
				if let errorMessage = self.vm.errMessage {
					Text(errorMessage)
				} else {
					LazyVStack {
						ForEach(self.vm.books, id: \.id) { book in
							HStack {
								Text(book.title)
								Text(book.authorsText)
								Text("\(book.price)원")
							}
							.task {
								if let lastIndex = self.vm.books.lastIndex(where: { $0.id == book.id }),
								   lastIndex >= vm.books.count - 3,
								   self.vm.hasMorePage {
									await self.vm.loadMore(query: query)
								}
							}
						}
					}
				}
			}
			.padding()
			.padding(.top, 30)
		}
    }
}

#Preview {
    KakaoNetworkExerciseView()
}
