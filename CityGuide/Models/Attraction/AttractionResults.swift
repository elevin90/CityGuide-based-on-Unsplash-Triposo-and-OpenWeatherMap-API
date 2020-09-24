//
//  AttractionResults.swift
//  CityGuide
//
//  Created by Evgeniy Levin on 8/9/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import Foundation

struct AttractionResults: Codable {
    
    let all: [Attraction]
    
    enum CodingKeys: String, CodingKey {
        case all = "results"
    }
}
