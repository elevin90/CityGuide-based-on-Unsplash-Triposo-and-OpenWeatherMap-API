//
//  WeatherService.swift
//  WeatherLocation
//
//  Created by Evgeniy Levin on 8/9/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherAPI {
    func weather(for city: String, handler: @escaping (Result<WeatherForecast, Error>) -> Void)
    func image(with title: String, handler: @escaping (Result<Data, Error>) -> Void)
}

class WeatherService {
    
    private let endPoint = "http://api.openweathermap.org/"
    private let token: String
    
    init() {
        if let path = Bundle.main.path(forResource: "AppSandbox", ofType: "plist"), let keys = NSDictionary(contentsOfFile: path),
            let key = keys["WeatherKey"] as? String {
            token = key
        } else {
            token = ""
        }
    }
}

extension WeatherService: WeatherAPI {
    public  func weather(for city: String, handler: @escaping (Result<WeatherForecast, Error>) -> Void) {
        guard let url = url(for: city) else { return  }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                handler(.failure(error))
                return
            }
            guard let data = data else { return }
            let forecast = try? JSONDecoder().decode(WeatherForecast.self, from: data)
            if let weatherForecast = forecast {
                handler(.success(weatherForecast))
            }
        }.resume()
    }
    
    private func url(for city: String) -> URL? {
        let url = URL(string: "\(endPoint)data/2.5/weather")
        guard let forecastURL = url else { return nil }
        var components = URLComponents(url: forecastURL, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "q", value: city),
                                  URLQueryItem(name: "APPID", value: token)]
        guard let requestURL = components?.url else { return nil }
        let request = URLRequest(url: requestURL)
        return request.url
    }
    
    public func image(with title: String, handler: @escaping (Result<Data, Error>) -> Void) {
        let url = URL(string: "\(endPoint)wn/(title).png")
        guard let pictureURL = url else { return }
        URLSession.shared.dataTask(with: pictureURL) { (data, response, error) in
            
        }
    }
}
