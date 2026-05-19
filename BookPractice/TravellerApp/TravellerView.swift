//
//  TravellerView.swift
//  BookPractice
//
//  Created by YoonieMac on 5/19/26.
//

import SwiftUI

struct TravellerView: View {
	
	@State private var vm: TravellerViewModel = .init()
	
    var body: some View {
		VStack(alignment: .leading, spacing: 50) {
			VStack(spacing: 15) {
				HStack {
					Text("Practice 04")
					Spacer()
				}
				HStack {
					Text("TaskGroup")
					Spacer()
				}
			}
			.font(.largeTitle)
			.fontWeight(.ultraLight)
			
            Button(action: {
				Task {
						await self.vm.fetchAllWeathers()
					}
			}, label: {
                Text(self.vm.isLoading ? "날씨 조회 중..." : "날씨 조회")
					.frame(maxWidth: .infinity)
			})
			.buttonStyle(.borderedProminent)
            .disabled(self.vm.isLoading)
			
            if self.vm.isLoading {
                VStack {
                    Spacer()
                    HStack(alignment: .center) {
                        Spacer()
                        ProgressView("날씨 조회 중...")
                            .scaleEffect(1.5)
                        Spacer()
                    }
                    Spacer()
                }
            } else {
                VStack(alignment: .leading, spacing: 40) {
                    ForEach(vm.cityWeathers, id: \.city) { cityWeather in
                        HStack(spacing: 20) {
                            Text(cityWeather.temperatureText)
                            Spacer()
                            Text(cityWeather.fetchedTimeText)
                        }
                    }
                    if !self.vm.elapedTime.isEmpty {
                        Text("⏱ 총 소요시간: \(vm.elapedTime)초")
                    }
                }
			}
			Spacer()
		}
		.padding(30)
    }
}

#Preview {
    TravellerView()
}
