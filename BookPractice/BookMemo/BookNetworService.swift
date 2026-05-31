//
//  BookNetworService.swift
//  BookPractice
//
//  Created by YoonieMac on 5/25/26.
//

import Foundation

actor BookNetworkService {
    
    static let shared = BookNetworkService()
    
    private let kakaoApiKey: String = {
        guard let apiKey = Bundle.main.infoDictionary?["KAKAO_API_KEY"] as? String else { return "인증 키가 잘못되었습니다" }
        return apiKey
    }()
    
    private let basicUrl: String = "https://dapi.kakao.com/v3/search/book"
    
    var booksFromKakaoData: [Book] = []
    
    
    private init() {}
    
	func searchBooksFromKakaoData(query: String, size: Int, pages: Int) async throws -> [Book] {
        do {
            let url = try self.createURL(query: query, size: size, pages: pages )
            let request = self.createURLRequest(url: url)
            let (data, res) = try await URLSession.shared.data(for: request)
            guard let response = res as? HTTPURLResponse,
                  response.statusCode >= 200 && response.statusCode < 300 else { throw BookError.invalidResponse }
            let bookResponse = try JSONDecoder().decode(BookResponse.self, from: data)
            let results: [Book] = bookResponse.documents.map {
                Book(
                    title: $0.title,
                    authors: $0.authors,
                    price: $0.salePrice,
                    isbn: $0.isbn,
                    thumbnailUrlString: $0.thumbnailUrlString,
                    contents: $0.contents
                )
            }
            return results
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

extension BookNetworkService {
    private func createURL(query: String, size: Int, pages: Int) throws -> URL {
        var components: URLComponents? = URLComponents(string: basicUrl)
        components?.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "size", value: String(size)),
            URLQueryItem(name: "page", value: String(pages))
        ]
        guard let compo = components,
              let url = compo.url else { throw BookError.invalidURL }
        
        return url
	}
    
    private func createURLRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK \(kakaoApiKey)", forHTTPHeaderField: "Authorization")
        return request
    }
}
