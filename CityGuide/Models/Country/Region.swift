//
//  File.swift
//  WeatherLocation
//
//  Created by Evgeniy Levin on 8/9/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import Foundation

struct Region {
    
    let title: String
    var countries: [Country]
    let imageTitle: String
    
    enum RegionType: String {
        case Europe  = "Europe"
        case America = "America"
        case Asia    = "Asia"
        case Africa  = "Africa"
    }
    
    init(title: String, countries: [Country], imageTitle: String) {
        self.title = title
        self.countries = countries
        self.imageTitle = imageTitle
    }
    
    init(from savedRegion: SavedRegion) {
        title = savedRegion.title ?? ""
        imageTitle = savedRegion.imageName ?? ""
        countries = []
        guard let savedCountries = savedRegion.countries else { return }
            for savedCountry in savedCountries  {
                if let country =  savedCountry as? SavedCountry {
                  countries.append(Country(with:country))
            }
        }
    }
}
