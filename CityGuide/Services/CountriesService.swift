//
//  CountriesService.swift
//  WeatherLocation
//
//  Created by Evgeniy Levin on 8/9/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import Foundation


final class CountriesService {
    
    static let shared = CountriesService()
    let baseURL = "https://restcountries.eu/"
    
    private init() {}
    
    func loadAllCountries(handler: @escaping (Result<[Country], Error>) -> Void) {
        let countriesURL = URL(string: "\(baseURL)rest/v2")!
        URLSession.shared.dataTask(with: countriesURL) { (data, response, error) in
            guard let data = data else { handler(.failure(error!)); return }
            let models = try? JSONDecoder().decode([Country].self, from: data)
            print(models?.count ?? 0)
            handler(.success(models ?? []))
        }.resume()
    }
}
