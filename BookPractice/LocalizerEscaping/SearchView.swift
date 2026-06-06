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
                textFieldView
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
                Button("검색") {
                    Task {
                        await searchVM.searchBooks(query: searchText)
                    }
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
