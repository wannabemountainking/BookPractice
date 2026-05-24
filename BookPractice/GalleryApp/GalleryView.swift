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
                    Text("Practice 05")
                    Spacer()
                }
                HStack {
                    Text("AsyncImage Phase")
                    Spacer()
                }
            }
            .font(.largeTitle)
            .fontWeight(.ultraLight)
            .padding(.horizontal, 20)
            
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
                                        ProgressView("로딩 중...")
                                            .scaleEffect(1.5)
                                            .frame(maxWidth: .infinity)
                                            .foregroundStyle(.orange)
                                            .padding(50)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.green, lineWidth: 3)
                                                    .frame(maxWidth: .infinity)
                                            }
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        Text(item.title)
                                    }
                                    .padding(20)
                                case .success(let image):
                                    VStack(alignment: .center) {
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.green, lineWidth: 3)
                                                    .frame(maxWidth: .infinity)
                                            }
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        Text(item.title)
                                    }
                                    .padding(20)
                                    
                                case .failure:
                                    VStack(alignment: .center) {
                                        Image(systemName: "photo.badge.exclamationmark")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundStyle(.pink)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .strokeBorder(Color.red, lineWidth: 2)
                                                    .frame(maxWidth: .infinity)
                                            }
                                        Text("이미지 로드 실패")
                                    }
                                    .padding(20)
									
								@unknown default:
									EmptyView()
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
