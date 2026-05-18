//
//  Practice01View.swift
//  BookPractice
//
//  Created by yoonie on 5/18/26.
//

import SwiftUI

struct Practice01View: View {
    private let service: WeatherService = .shared
    @State private var weatherInfo: String = ""
	@State private var showSuccess: Bool = false
	@State private var buttonClicked: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 50) {
            VStack(spacing: 15) {
                HStack {
                    Text("Practice 01")
                    Spacer()
                }
                HStack {
                    Text("URLComponents")
                    Spacer()
                }
            }
            .font(.largeTitle)
            .fontWeight(.ultraLight)
            
            Button(action: {
                Task {
					buttonClicked.toggle()
                    do {
                        self.weatherInfo = try await service.fetchWeather(city: "seoul")
						self.showSuccess = true
                    } catch let error as WeatherError {
                        switch error {
						case .invalidURL:
							self.weatherInfo = error.errorDescription ?? "invalidURL Error"
                        case .networkError:
							self.weatherInfo = error.errorDescription ?? "unknown Error"
                        }
						self.showSuccess = false
                    } catch {
                        self.weatherInfo = error.localizedDescription
						self.showSuccess = false
                    }
                }

            }, label: {
				Text(buttonClicked ? "원상복귀" : "URL 생성 테스트")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
			
			if buttonClicked {
				VStack {
					Text(weatherInfo)
					Text(showSuccess ? "✅ 성공" : "❌ 실패")
				}
			}
			Spacer()
        }
        .padding(30)
    }
}

#Preview {
    Practice01View()
}
