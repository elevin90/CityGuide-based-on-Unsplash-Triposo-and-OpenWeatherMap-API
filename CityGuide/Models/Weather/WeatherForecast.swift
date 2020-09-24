//
//  WeatherForecast.swift
//  WeatherLocation
//
//  Created by Evgeniy Levin on 8/9/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import Foundation

enum WeatherType: String {
    case clearSky = "clear sky"
    case minorClouds = "few clouds"
    case scatteredClouds = "scattered clouds"
    case brokenClouds = "broken clouds"
    case overcastClouds = "overcast clouds"
    case lightDrizzly = "light intensity drizzle"
    case lightRain  = "light rain"
    case showerRain = "shower rain"
    case moderateRain = "moderate rain"
    case mist       = "mist"
}

struct WeatherRawForecast: Codable {
    let list: [WeatherForecast]
}

struct WeatherForecast: Codable {
    let temperature: Temperature
    let wind: Wind
    let weather: [Weather]
 
    enum CodingKeys: String, CodingKey {
        case temperature = "main"
        case wind        = "wind"
        case weather     = "weather"
    }
}

struct Temperature {
    let minimal: Double
    let maximal: Double
    let average: Double
    
    var temperatureString: String {
        let diffString = String(format: "%.1f", average - 273.15)
        return "\(diffString)˚C"
    }
}

extension Temperature: Codable {
    enum CodingKeys: String, CodingKey {
        case minimal = "temp_min"
        case maximal = "temp_max"
        case average = "temp"
    }
}

struct Weather {
    let description: String
    let conditions: String
}

extension Weather: Codable {
    enum CodingKeys: String, CodingKey {
        case description = "description"
        case conditions  = "main"
    }
}
