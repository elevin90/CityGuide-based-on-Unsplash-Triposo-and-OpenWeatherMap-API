//
//  Wind.swift
//  WeatherLocation
//
//  Created by Evgeniy Levin on 8/9/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import Foundation

struct Wind {
    let speed: Double
    let temperature: Double
}

extension Wind: Codable {
    enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case temperature = "deg"
    }
}
