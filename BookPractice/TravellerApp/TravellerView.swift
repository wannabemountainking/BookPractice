//
//  TravellerView.swift
//  BookPractice
//
//  Created by YoonieMac on 5/19/26.
//

import SwiftUI

struct TravellerView: View {
	
	@State private var vm: TravellerViewModel = .init()
	@State private var buttonClicked: Bool = false
	
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
					buttonClicked.toggle()
					if buttonClicked {
						await self.vm.fetchAllWeathers()
					} else {
						self.vm.clearAll()
					}
				}
			}, label: {
				Text("날씨 조회")
					.frame(maxWidth: .infinity)
			})
			.buttonStyle(.borderedProminent)
			
			if buttonClicked {
				VStack(alignment: .leading, spacing: 40) {
					ForEach(vm.cityWeathers, id: \.city) { cityWeather in
						HStack(spacing: 20) {
							Text(cityWeather.temperatureText)
							Spacer()
							Text(cityWeather.fetchedTimeText)
						}
					}
					if !self.vm.isLoading {
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
