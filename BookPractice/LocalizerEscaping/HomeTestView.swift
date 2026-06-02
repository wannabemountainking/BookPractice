//
//  HomeTestView.swift
//  BookPractice
//
//  Created by YoonieMac on 6/2/26.
//

import SwiftUI

struct HomeTestView: View {
	@State private var vm: HomeViewModel = .init()
	
    var body: some View {
		VStack {
			
			List {
				ForEach(vm.categoryBooks.keys.sorted(), id: \.self) { category in
					Section("\(category) 총 \(vm.categoryBooks[category]!.count)권") {
						ForEach(vm.categoryBooks[category] ?? [], id: \.id) { book in
							HStack {
								Text(book.title)
								Text(book.authorsText)
								Text(book.priceText)
							}
							.task {
								let books = vm.categoryBooks[category] ?? []
								print(vm.categoryHasMorePage)
								if let lastIndex = books.firstIndex(where:  { $0.id == book.id }),
								   lastIndex >= books.count - 1 {
									await vm.loadCategoryMore(category: category)
								}
							}
						}
					}
				}
			}
		}
    }
}

#Preview {
    HomeTestView()
}
