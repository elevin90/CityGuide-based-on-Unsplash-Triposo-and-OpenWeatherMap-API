//
//  RegionDetailsPresenter.swift
//  CityGuide
//
//  Created by Evgeniy Levin on 8/12/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import Foundation

protocol RegionDetailsPresenting {
    var regionTitle: String { get }
    var countriesCount: Int { get }
    var imageTitle: String { get }
    func country(at index: IndexPath) -> Country
    func filterCountries(searchText: String, completion: (()->()))
}

class RegionDetailsPresenter {
    
    private let region: Region
    var countries = [Country]()
    
    init(with region: Region) {
        self.region = region
        self.countries = region.countries
    }
}

extension RegionDetailsPresenter: RegionDetailsPresenting {
    var regionTitle: String {
        return region.title
    }
    
    var countriesCount: Int {
        return countries.count
    }
    
    var imageTitle: String {
        return region.imageTitle
    }
    
    func country(at index: IndexPath) -> Country {
        return countries[index.row]
    }
    
    func filterCountries(searchText: String, completion: (() -> ())) {
        guard !searchText.isEmpty else {
            countries = region.countries
            completion()
            return
        }
        countries = region.countries.filter{ $0.title.range(of: searchText, options: .caseInsensitive) != nil }
        completion()
    }
}
