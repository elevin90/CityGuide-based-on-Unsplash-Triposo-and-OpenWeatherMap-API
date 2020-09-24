//
//  WeatherServiceTests.swift
//  CityGuideTests
//
//  Created by Evgeniy Levin on 8/15/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import XCTest
@testable import CityGuide

class ServicesTests: XCTestCase {

    let service = WeatherService.init()
    
    override func setUp() { }
    
    func testWeatherForecast() {
        let endQueryExpectation = expectation(description: "EndQueryExpectation")
        service.weather(for: "Minsk") { (result) in
            switch result {
            case .success(_):
                XCTAssert(true)
                endQueryExpectation.fulfill()
            case .failure(let error):
                XCTAssert(false, error.localizedDescription)
                endQueryExpectation.fulfill()
            }
        }
         wait(for: [endQueryExpectation], timeout: 5.0)
    }
}

class RegionsServiceTests: XCTestCase {
    
    override func setUp() { }
    
    let service = CountriesService.shared
    
    func testCountriesRequest() {
        let endQueryExpectation = expectation(description: "EndQueryExpectation")
        service.loadAllCountries { (result) in
            switch result {
                case .success(let countries):
                    XCTAssertNotEqual(countries.count, 0, "Empty countries list")
                    XCTAssert(true)
                    endQueryExpectation.fulfill()
                case .failure(let error):
                    XCTAssert(false, error.localizedDescription)
                    endQueryExpectation.fulfill()
            }
        }
         wait(for: [endQueryExpectation], timeout: 5.0)
    }
}

class AttractionsServiceTests: XCTestCase {
    
    override func setUp() { }
    
    let service = AttractionService.shared
    
    func testCountriesRequest() {
        let endQueryExpectation = expectation(description: "EndQueryExpectation")
        service.attractionsInCity(title: "Minsk") { (result) in
            switch result {
                case .success(let attractions):
                XCTAssertNotEqual(attractions.count, 0, "Empty countries list")
                XCTAssert(true)
                endQueryExpectation.fulfill()
                case .failure(let error):
                XCTAssert(false, error.localizedDescription)
                endQueryExpectation.fulfill()
            }
        }
        wait(for: [endQueryExpectation], timeout: 5.0)
    }
}
