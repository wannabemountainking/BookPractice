//
//  File.swift
//  BookPractice
//
//  Created by YoonieMac on 5/28/26.
//

import Foundation


class UserProfile {
	var name: String
	var age: Int
	var email: String
	
	init(name: String, age: Int, email: String) {
		self.name = name
		self.age = age
		self.email = email
	}
	
	convenience init(name: String) {
		self.init(name: name, age: 0, email: "")
	}
	
	func myPrint() {
		print(self)
	}
}

enum ProfileError: LocalizedError {
	case invalidAge
	case emptyName
	
	var errorDescription: String? {
		switch self {
		case .invalidAge: return "나이가 유효하지 않습니다"
		case .emptyName: return "이름을 입력하지 않았습니다"
		}
	}
}


