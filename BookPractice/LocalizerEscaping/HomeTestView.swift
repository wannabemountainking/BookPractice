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
		ScrollView {
			ForEach(vm.categoryBooks.keys.sorted(), id: \.self) { category in
				Section("\(category) 총 \(vm.categoryBooks[category]!.count)권") {
					ScrollView(.horizontal) {
						LazyHStack {
							ForEach(vm.categoryBooks[category] ?? [], id: \.id) { book in
								ZStack {
									RoundedRectangle(cornerRadius: 10)
										.fill(Color.gray.opacity(0.1))
										.frame(width: 100, height: 100)
										.overlay(alignment: .leading) {
											Text(book.title)
										}
								}
								.task {
									let books = vm.categoryBooks[category] ?? []
									if let lastIndex = books.firstIndex(where:  { $0.id == book.id }),
									   lastIndex >= books.count - 1 {
										await vm.loadCategoryMore(category: category)
										print("iOS books count: \(vm.categoryBooks["iOS"]?.count ?? 0)")
									}
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
