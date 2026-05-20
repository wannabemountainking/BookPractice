//
//  GalleryItem.swift
//  BookPractice
//
//  Created by yoonie on 5/20/26.
//

import Foundation


struct GalleryItem {
	
	static let mockList: [GalleryItem] = [
		GalleryItem(title: "무제1", imageURL: "https://picsum.photos/seed/1/400/300"),
		GalleryItem(title: "무제2", imageURL: "https://picsum.photos/seed/2/400/300"),
		GalleryItem(title: "무제3", imageURL: "https://picsum.photos/seed/3/400/300"),
		GalleryItem(title: "무제4", imageURL: "https://picsum.photos/seed/4/400/300"),
		GalleryItem(title: "무제5", imageURL: "https://picsum.photos/seed/broken/400/300")
	]
	
    let id = UUID()
    let title: String
    let imageURL: String
}

