//
//  Attraction.swift
//  CityGuide
//
//  Created by Evgeniy Levin on 8/9/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import Foundation
import CoreLocation

struct Attraction {
    let title: String
    let links: [AttractionLink]
    let raiting: Double
    let location: AttractionLocation
    
    
    init(from savedAttraction: SavedAttraction) {
        title = savedAttraction.title ?? ""
        links = []
        raiting = savedAttraction.raiting
        location = AttractionLocation(latitude: savedAttraction.latitude,
                                      longitude: savedAttraction.longtitude)
    }
    
}

extension Attraction: Codable {
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case raiting = "score"
        case links = "attribution"
        case location = "coordinates"
    }
}


