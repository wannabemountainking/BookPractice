//
//  KakaoNetworkExerciseView.swift
//  BookPractice
//
//  Created by YoonieMac on 5/30/26.
//

import SwiftUI

struct KakaoNetworkExerciseView: View {
	
	@State private var service: KakaoService = .shared
	@State private var query: String = ""
	@State private var errorMessage: String?
	@State private var books: [Book] = []
	
    var body: some View {
		VStack {
			HStack {
				TextField("책을 찾아라", text: $query)
				Spacer()
				Button {
					//Action
					Task {
						do {
							self.books = try await self.service.searchBooks(query: query)
						} catch let error as NetworkError {
							switch error {
							case .invalidURL:
								self.errorMessage = "URL 오류"
							case .invalidResponse:
								self.errorMessage = "서버 응답 오류"
							case .parsingError:
								self.errorMessage = "파싱 오류"
							case .networkError:
								self.errorMessage = "네크워크 오류"
							}
						}
					}
				} label: {
					Text("책을 찾아요")
				}
			}
			if let errorMessage {
				Text(errorMessage)
			} else {
				List {
					ForEach(self.books, id: \.id) { book in
						HStack {
							Text(book.title)
							Text(book.authorsText)
							Text("\(book.price)원")
						}
					}
				}
			}
		}
    }
}

#Preview {
    KakaoNetworkExerciseView()
}
