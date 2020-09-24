//
//  CountryImage.swift
//  CityGuide
//
//  Created by Evgeniy Levin on 8/13/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import Foundation

struct CityImages: Codable {
    
    let results: [CityImage]
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}

struct CityImage: Codable {
   // let description: String
    let urls: ImageLink
 
    enum CodingKeys: String, CodingKey {
     //   case description = "description"
        case urls = "urls"
    }
}

struct ImageLink {
    let link: String
}

extension ImageLink: Codable {
    enum CodingKeys:  String, CodingKey {
        case link = "small"
    }
}
