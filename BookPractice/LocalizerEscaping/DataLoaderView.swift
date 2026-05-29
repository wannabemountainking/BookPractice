//
//  DataLoaderView.swift
//  BookPractice
//
//  Created by YoonieMac on 5/28/26.
//

import SwiftUI

struct DataLoaderView: View {
	
    var body: some View {
		
    }
}

#Preview {
    DataLoaderView()
}


final class DataLoader {
	
	func load(completion: @escaping (String) -> Void) {
		DispatchQueue.global().async {
			completion("데이터 로드 완료")
		}
	}
}
