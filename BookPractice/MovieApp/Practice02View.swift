//
//  Practice02View.swift
//  BookPractice
//
//  Created by YoonieMac on 5/18/26.
//

import SwiftUI

struct Practice02View: View {
	
	private let movieData: Data = Movie.mockData
	@State private var buttonClicked: Bool = false
	@State private var title: String = ""
	@State private var runtime: String = ""
	@State private var genre: String = ""
	@State private var errorMessage: String? = nil
	
    var body: some View {
		VStack(alignment: .leading, spacing: 50) {
			VStack(spacing: 15) {
				HStack {
					Text("Practice 02")
					Spacer()
				}
				HStack {
					Text("Codable + CodingKeys")
					Spacer()
				}
			}
			.font(.largeTitle)
			.fontWeight(.ultraLight)
			
			Button(action: {
				do {
					let decodedData = try JSONDecoder().decode(Movie.self, from: self.movieData)
					self.title = decodedData.displayTitle
					self.runtime = decodedData.runningTimeText
					self.genre = decodedData.genreText

					errorMessage = nil
				} catch {
					print(error.localizedDescription)
					errorMessage = error.localizedDescription
				}
				buttonClicked.toggle()
			}, label: {
				Text(buttonClicked ? "Back" : "JSON Decoding Test")
					.frame(maxWidth: .infinity)
			})
			.buttonStyle(.borderedProminent)
			
			if buttonClicked {
				VStack(alignment: .leading, spacing: 10) {
					if let errorMessage {
						Text(errorMessage)
					} else {
						Text(self.title)
						HStack {
							Text(self.runtime)
							Text(" | ")
							Text(self.genre)
						}
					}
					Text(errorMessage == nil ? "✅ 성공" : "❌ 실패")
						.padding(.top, 20)
				}
			}
			Spacer()
		}
		.padding(30)
    }
}

#Preview {
    Practice02View()
}
