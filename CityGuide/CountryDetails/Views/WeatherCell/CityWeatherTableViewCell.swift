//
//  CityWeatherTableViewCell.swift
//  CityGuide
//
//  Created by Evgeniy Levin on 8/14/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import UIKit

class CityWeatherTableViewCell: UITableViewCell, NibLoadableView {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func prepare(with forecast: WeatherForecast) {
        temperatureLabel.text = forecast.temperature.temperatureString
        guard let conditions  = forecast.weather.first?.description else { return }
        weatherDescriptionLabel.text = conditions.firstUppercased
        if conditions == WeatherType.clearSky.rawValue {
            weatherImageView.image = #imageLiteral(resourceName: "sunny")
        } else if conditions == WeatherType.minorClouds.rawValue
            || conditions == WeatherType.scatteredClouds.rawValue
            || conditions == WeatherType.brokenClouds.rawValue
            || conditions == WeatherType.overcastClouds.rawValue
            || conditions == WeatherType.mist.rawValue {
            weatherImageView.image = #imageLiteral(resourceName: "sunAndClouds")
        } else if conditions == WeatherType.lightDrizzly.rawValue
            || conditions == WeatherType.lightRain.rawValue
            || conditions == WeatherType.showerRain.rawValue
            || conditions == WeatherType.moderateRain.rawValue {
            weatherImageView.image = #imageLiteral(resourceName: "rain")
        } else {
            weatherImageView.image  = #imageLiteral(resourceName: "cloud")
        }
    }
}
