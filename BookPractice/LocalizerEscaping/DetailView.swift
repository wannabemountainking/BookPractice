//
//  DetailView.swift
//  BookPractice
//
//  Created by yoonie on 6/8/26.
//

import SwiftUI
import SwiftData
import WebKit


struct DetailView: View {
    
    // 중요 properties
    let book: Book
    @State private var myDenVM: MyDenViewModel = .init()
    
    // 환경 properties
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    // 상태 properties
    @State private var showBookmarkAlert: Bool = false
    @State private var bookmarkMessage: String = ""
    @State private var forceUpdateTrigger: Bool = false
    
    var body: some View {
        NavigationStack {
            <#code#>
        }
    }
}

#Preview {
    let book = Book(
        title: "바람과 함께",
        authors: ["김도윤"],
        price: 10000,
        isbn: "4590305015",
        thumbnailUrlString: "http://yoonie.com",
        contents: "나는 자연인이다"
    )
    DetailView(book: book)
        .modelContainer(for: MyFavBook.self, inMemory: true)
}
