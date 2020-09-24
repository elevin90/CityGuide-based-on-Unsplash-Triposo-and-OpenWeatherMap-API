//
//  AttractionLink.swift
//  CityGuide
//
//  Created by Evgeniy Levin on 8/9/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import Foundation

struct AttractionLink: Codable {
    
    let source: String
    let link: String
    
    enum CodingKeys: String, CodingKey {
        case source = "source_id"
        case link = "url"
    }
}
