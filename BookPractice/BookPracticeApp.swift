//
//  BookPracticeApp.swift
//  BookPractice
//
//  Created by yoonie on 5/17/26.
//

import SwiftUI
import SwiftData

@main
struct BookPracticeApp: App {
    var body: some Scene {
        WindowGroup {
            HomeTestView()
        }
		.modelContainer(for: MyFavBook.self)
    }
}
