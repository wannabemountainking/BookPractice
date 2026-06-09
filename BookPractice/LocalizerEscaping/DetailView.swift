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
			ZStack(alignment: .leading) {
				Color.orange.opacity(0.1).ignoresSafeArea()
				
				ScrollView(.vertical) {
					bookMainInfoSection
					bookContentSection
					actionButtonSection
				}
			}
			.navigationTitle(book.title)
			.navigationBarTitleDisplayMode(.large)
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					if isBookmarked {
						Button("", systemImage: "bookmark.fill") {
							myDenVM.toggleBookmark(book: book)
						}
					} else {
						Button("", systemImage: "bookmark") {
							myDenVM.toggleBookmark(book: book)
							showBookmarkAlert = true
						}
					}
				}
				ToolbarItem(placement: .topBarTrailing) {
					Button("닫기", systemImage: "xmark.circle.fill") {
						dismiss()
					}
					.foregroundStyle(.white)
					.background(Color.gray.opacity(0.3))
				}
			}
			.onAppear {
				myDenVM.setModelContext(context: modelContext)
			}
        }
    }

	@ViewBuilder
	private var bookMainInfoSection: some View {
		HStack {
			AsyncImage(url: URL(string: book.thumbnailUrlString))
				.frame(width: 100, height: 150)
			
			VStack(alignment: .leading ) {
				Spacer()
				Text("저자: \(book.authorsText)")
				Text("가격: \(book.priceText)")
				Text(book.isbnText)
			}
		}
		.padding()
	}
	
	@ViewBuilder
	private var bookContentSection: some View {
		VStack(alignment: .leading) {
			Text("책 소개")
				.font(.title3)
			Text(book.contents)
		}
		.padding()
	}
	
	@ViewBuilder
	private var actionButtonSection: some View {
		HStack {
			NavigationLink("상세 페이지 보기") {
				WebView(url: book.bookURL)
					.edgesIgnoringSafeArea(.all)
			}
			.padding(.horizontal)
			Spacer()
		}
		
		ShareLink(
			item: sharedText,
			subject: Text(book.title),
			message: Text("\(book.title) 책 공유"),
			label: {
				HStack(alignment: .bottom, spacing: 20) {
					Image(systemName: "square.and.arrow.up")
						.resizable()
						.frame(width: 20, height: 30)
						.scaledToFit()
					Text("이 책을 공유합니다")
					
					Spacer()
				}
				.padding(.horizontal)
			}
		)
	}
	
	
	
	@ViewBuilder
	private var toastNotification: some View {
		VStack(spacing: 0) {
			HStack(spacing: 20) {
				Image(systemName: bookmarkMessage.contains("추가") ? "book.vertical.fill" : "book.vertical")
					.resizable()
					.frame(width: 20, height: 20)
					.foregroundStyle(Color.orange)
				
				Text(bookmarkMessage)
				
			}
			.padding()
		}
		.transition(.move(edge: .top).combined(with: .opacity))
		.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
				showBookmarkAlert = false
			}
		}
	}
	
	private var isBookmarked: Bool {
		let _ = forceUpdateTrigger
		return myDenVM.isBookmarked(book: book)
	}
	
	
	private var sharedText: String {
"""
--- \(book.title) ---
		
저자: \(book.authorsText)
가격: \(book.priceText)
ISBN: \(book.isbnText)

내용
\(book.contents)

자세히 보기
\(book.url)

"""
	}
}

#Preview {
    let book = Book(
        title: "바람과 함께",
        authors: ["김도윤"],
        price: 10000,
        isbn: "4590305015",
        thumbnailUrlString: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F5562664",
        contents: "Unleash the power of declarative programming in SwiftUI with practical recipes for building cross-platform Apple applications for iOS 14, macOS, and watchOS using Swift 5.3, Xcode 12, and SwiftUI 2.0  ▶Book Description SwiftUI is an innovative and simple way",
		url: "https://search.daum.net/search?w=bookpage&bookId=5562664&q=SwiftUI+Essentials+-+iOS+14+Edition"
    )
    DetailView(book: book)
        .modelContainer(for: MyFavBook.self, inMemory: true)
}
