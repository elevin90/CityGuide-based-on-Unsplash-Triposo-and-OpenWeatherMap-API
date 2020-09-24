//
//  AppRouter.swift
//  CityGuide
//
//  Created by Evgeniy Levin on 8/13/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import UIKit

enum Routing {
    case regionDetails
    case countryDetails
    case map
}

protocol AppRouting {
    func route(type: Routing, from currentVC: UIViewController, with  object: Any)
    func showError(title: String?, message: String, from currentVC: UIViewController)
}

class AppRouter: AppRouting {
    func showError(title: String?, message: String, from currentVC: UIViewController) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        currentVC.present(alertVC, animated: true, completion: nil)
    }
    
    func route(type: Routing, from currentVC: UIViewController, with object: Any) {
        switch type {
        case .regionDetails:
            guard let region = object as? Region else { return }
            let regionDetailsPresenter = RegionDetailsPresenter(with: region)
            let regionDetailsViewController = RegionDetailsViewController(with: regionDetailsPresenter)
            currentVC.navigationController?.pushViewController(regionDetailsViewController, animated: true)
        case .countryDetails:
            guard let country = object as? Country else { return }
            let presenter = CountryDetailsPresenter(country: country)
            let cityDetailsVC = CountryDetailsViewController(presenter: presenter)
            currentVC.navigationController?.pushViewController(cityDetailsVC, animated: true)
        case .map:
            guard let attraction = object as? Attraction else { return }
            let presenter = AttractionOnMapPresenter(with: attraction)
            let attractionVC = AttractionMapViewController(with: presenter)
            currentVC.navigationController?.present(attractionVC, animated: true, completion: nil)
        }
    }
}
