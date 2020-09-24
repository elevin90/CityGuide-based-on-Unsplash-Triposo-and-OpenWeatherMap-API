//
//  City.swift
//  WeatherLocation
//
//  Created by Evgeniy Levin on 8/9/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import Foundation
import CoreLocation

struct Country {
    let title: String
    let capital: String
    let region: String
    let subregion: String
    let population: Int
    let borders: [String]
    let coordinates: [Double]
    let flagPath: String
    
    var location: CLLocation {
        return CLLocation(latitude: coordinates[0], longitude: coordinates[1])
    }
    
    init(with savedCountry: SavedCountry) {
        title = savedCountry.title ?? ""
        capital = savedCountry.capital ?? ""
        region = savedCountry.country?.title ?? ""
        subregion = ""
        population = 0
        borders = []
        coordinates = [0, 0]
        flagPath = ""
    }
}

extension Country: Codable {
    enum CodingKeys: String, CodingKey {
        case title   = "name"
        case capital = "capital"
        case region  = "region"
        case population = "population"
        case subregion = "subregion"
        case borders    = "borders"
        case coordinates = "latlng"
        case flagPath = "flag"
    }
}



