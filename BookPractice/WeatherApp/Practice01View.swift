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
                    do {
                        self.weatherInfo = try await service.fetchWeather(city: "seoul")
                    } catch let error as WeatherError {
                        switch error {
                        case .invalidURL: return error.errorDescription
                        case .networkError: return error.errorDescription
                        }
                    } catch {
                        self.weatherInfo = error.localizedDescription
                    }
                }
            }, label: {
                Text("URL 생성 테스트")
                    .frame(maxWidth: .infinity)
            })
            
            
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    Practice01View()
}
