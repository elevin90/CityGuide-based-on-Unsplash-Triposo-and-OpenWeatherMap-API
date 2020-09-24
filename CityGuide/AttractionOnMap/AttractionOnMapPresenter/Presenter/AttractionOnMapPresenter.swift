//
//  AttractionOnMapPresenter.swift
//  CityGuide
//
//  Created by Evgeniy Levin on 8/14/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import Foundation

protocol AttractionOnMapPresenting {
    var attraction: Attraction { get }
}

class AttractionOnMapPresenter: AttractionOnMapPresenting {
    
    let attraction: Attraction
    
    init(with attraction: Attraction) {
        self.attraction = attraction
    }
    
    
}
