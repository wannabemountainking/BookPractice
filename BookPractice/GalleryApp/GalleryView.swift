//
//  GalleryView.swift
//  BookPractice
//
//  Created by yoonie on 5/20/26.
//

import SwiftUI

struct GalleryView: View {
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
            
            ScrollView(.vertical) {
                LazyVStack(
                    alignment: .center,
                    spacing: 20,
                    content: {
                        ForEach(GalleryItem.mockList, id: \.id) { item in
                            AsyncImage(url: URL(string: item.imageURL)) { phase in
                                switch phase {
                                case .empty:
                                    VStack(alignment: .center) {
                                        RoundedRectangle(cornerRadius: 10)
                                            .strokeBorder(Color.green, lineWidth: 2)
                                            .frame(maxWidth: .infinity)
                                            .overlay(content: {
                                                ProgressView("로딩 중...")
                                                    .scaleEffect(1.3)
                                                    .foregroundStyle(.orange)
                                            })
                                            .background(Color.yellow.opacity(0.2))
                                        Text(item.title)
                                    }
                                case .success(let image):
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(Color.green, lineWidth: 2)
                                        .frame(maxWidth: .infinity)
                                        .overlay(content: {
                                            image
                                                .resizable()
                                                .frame(maxWidth: .infinity)
                                                .aspectRatio(contentMode: .fit)
                                        })
                                        .background(Color.yellow.opacity(0.2))
                                case .failure(let error):
                                    <#code#>
                                }
                            }
                        }
                    }
                )
            }
        }
    }
}


#Preview {
    GalleryView()
}
