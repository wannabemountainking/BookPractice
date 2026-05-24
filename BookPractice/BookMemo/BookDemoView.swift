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
    
    var body: some View {
        NavigationStack {
            
            TextField("책 이름이나 저자 이름을 입력하세요", text: $queryText)
                .font(.title3)
                .textFieldStyle(.roundedBorder)
                .padding(20)
            
            ScrollView(.vertical) {
                List {
                    ForEach(vm.currentBooks, id: \.id) { book in
                        VStack {
                            Text(book.title)
                                .fontWeight(.bold)
                            Text(book.authorsText)
                            Text(book.priceText)
                            Text(book.ratingText)
                        }
                    }
                }
            }
            .navigationTitle("My Books")
        }
    }
}

#Preview {
    BookDemoView()
}
