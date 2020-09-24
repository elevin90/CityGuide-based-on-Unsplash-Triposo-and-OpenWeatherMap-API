//
//  CityImagesService.swift
//  CityGuide
//
//  Created by Evgeniy Levin on 8/13/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import Foundation

final class CityImagesService {
    private let endpoint = "https://api.unsplash.com/"
    private let accountID: String
    
    static let shared = CityImagesService()
    
    private init() {
        guard let path = Bundle.main.path(forResource: "AppSandbox", ofType: "plist"), let keys = NSDictionary(contentsOfFile: path), let accountID = keys["Unsplash"] as? String else {
            self.accountID = ""; return
        }
        self.accountID = accountID
    }
    
    public func loadImages(for city: String, handler: @escaping(Result<[CityImage], Error>) -> Void) {
        guard let url = prepareRequestURL(city: city) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                handler(.failure(error))
                return
            }
            do {
                guard let data = data else { return }
                let imageLinks = try JSONDecoder().decode(CityImages.self, from: data)
                handler(.success(imageLinks.results))
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    private func prepareRequestURL(city: String) -> URL? {
        guard let url = URL(string: "\(endpoint)search/photos") else { return nil}
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            URLQueryItem(name: "query", value: city),
            URLQueryItem(name: "client_id", value: accountID),
        ]
        return components?.url
    }
}
