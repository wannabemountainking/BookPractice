//
//  Movie.swift
//  BookPractice
//
//  Created by YoonieMac on 5/18/26.
//

import Foundation


struct Movie: Codable {
	let movieID: String
	let titleKo: String
	let titleEn: String
	let releaseYear: Int
	let runningTime: Int
	let directorName: String
	let posterUrl: String
	let isPlayingNow: Bool
	let genreList: [String]
	
	enum CodingKeys: String, CodingKey {
		case movieID = "movie_id"
		case titleKo = "title_ko"
		case titleEn = "title_en"
		case releaseYear = "release_year"
		case runningTime = "running_time"
		case directorName = "director_name"
		case posterUrl = "poster_url"
		case isPlayingNow = "is_now_playing"
		case genreList = "genre_list"
	}
}

extension Movie {
	var displayTitle: String {
		return "\(self.titleKo) (\(self.titleEn))"
	}
	var runningTimeText: String {
		return "\(self.runningTime)분"
	}
	var genreText: String {
		return self.genreList.joined(separator: "  ·  ")
	}
}


extension Movie {
	private static let jsonString = """
		{
		"movie_id": "tt1234567",
		"title_ko": "인터스텔라",
		"title_en": "Interstellar",
		"release_year": 2014,
		"running_time": 169,
		"director_name": "크리스토퍼 놀란",
		"poster_url": "https://picsum.photos/200/300",
		"is_now_playing": true,
		"genre_list": ["SF", "드라마", "어드벤처"]
		}
		"""
	static var mockData: Data {
		guard let data = jsonString.data(using: .utf8) else {
			fatalError("UTF-8 인코딩 실패 — 절대 일어나면 안 되는 상황")
		}
		return data
	}
}
