//
//  CountryDetailsPresenter.swift
//  CityGuide
//
//  Created by Evgeniy Levin on 8/13/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import Foundation

protocol CountryDetailsPresenting {
    var country: Country { get }
    var weather: WeatherForecast? { get }
    var view: CountryDetailsView? { get set }
    var attractions: [Attraction] { get }
    var cityImages: [CityImage] { get }
}

class CountryDetailsPresenter: CountryDetailsPresenting {

    weak var view: CountryDetailsView?
    let country: Country
    var weather: WeatherForecast?
    var attractions: [Attraction] = []
    var cityImages: [CityImage] = []
    
    init(country: Country) {
        self.country = country
        loadAttractions()
        loadImages()
        loadWeatherForecast()
    }
    
    private func loadImages() {
        CityImagesService.shared.loadImages(for: country.capital) {[weak self] (result) in
            switch result {
            case .success(let links):
                DispatchQueue.main.async {
                    self?.cityImages = links
                    self?.view?.showCityImages(from: links)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loadAttractions() {
        guard Reachability.isConnectedToNetwork() else {
            manageOfflineAttractions()
            return
        }
        
        AttractionService.shared.attractionsInCity(title: country.capital) {[weak self] (result) in
            switch result {
            case .success(let attractions):
                self?.attractions = attractions
                DispatchQueue.global().async {
                    self?.saveAttractions()
                }
                DispatchQueue.main.async {
                    self?.view?.showAttractions()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func manageOfflineAttractions() {
        if let savedAttractions = CoreDataStack.shared.getall(type: .attraction) as? [SavedAttraction],
            !savedAttractions.isEmpty {
            attractions.removeAll()
            for savedAttraction in savedAttractions {
                if let countryTitle = savedAttraction.country?.title, countryTitle == country.title {
                    attractions.append(Attraction(from: savedAttraction))
                }
            }
            DispatchQueue.main.async {[weak self] in
                self?.view?.showAttractions()
            }
        }
    }
    
    private func saveAttractions() {
        let savedObjects = CoreDataStack.shared.getall(type: .country)
        guard let savedCountries = savedObjects as? [SavedCountry] else { return }
        for savedCountry in savedCountries  {
            if savedCountry.capital == country.capital {
                CoreDataStack.shared.saveAttractions(attractions: attractions, savedCountry: savedCountry)
            }
        }
    }
    
    private func loadWeatherForecast() {
        WeatherService().weather(for: country.capital, handler: {[weak self] (result) in
            switch result {
            case .success(let forecast):
                self?.weather = forecast
                DispatchQueue.main.async {
                    self?.view?.showWeather(forecast: forecast)
                }
            case .failure(let error):
                print(error)
            }
        })
    }
}
