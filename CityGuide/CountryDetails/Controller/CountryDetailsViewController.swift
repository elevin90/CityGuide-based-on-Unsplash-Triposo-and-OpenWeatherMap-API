//
//  CountryDetailsViewController.swift
//  CityGuide
//
//  Created by Evgeniy Levin on 8/13/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import UIKit

protocol CountryDetailsView: AnyObject {
    func showAttractions()
    func showCityImages(from imageLinks: [CityImage])
    func showWeather(forecast: WeatherForecast)
}

class CountryDetailsViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    private let router = AppRouter()
    private var presenter: CountryDetailsPresenting
    
    init(presenter: CountryDetailsPresenting) {
        self.presenter = presenter
        super.init(nibName: "CountryDetailsViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        prepareUI()
    }
    
    private func prepareUI() {
        tableView.dataSource = self
        tableView.delegate = self
        let attractionCellNib = UINib(nibName: AttractionTableViewCell.nibName, bundle: nil)
        let weatherCellNib = UINib(nibName: CityWeatherTableViewCell.nibName, bundle: nil)
        let headerNib = UINib(nibName: AttractionTableHeaderView.nibName, bundle: nil)
        tableView.register(attractionCellNib, forCellReuseIdentifier: AttractionTableViewCell.nibName)
        tableView.register(weatherCellNib, forCellReuseIdentifier: CityWeatherTableViewCell.nibName)
        tableView.register(CityImagesTableHeaderView.self, forHeaderFooterViewReuseIdentifier: CityImagesTableHeaderView.nibName)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: AttractionTableHeaderView.nibName)
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight =  10
        navigationItem.title = presenter.country.capital
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "left-arrow"), style: .plain,
                                                           target: self, action: #selector(onBack))
        view.backgroundColor = UIColor.appColor(.background)
    }
    
    @objc private func onBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension CountryDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 1
        case 2:
            return presenter.attractions.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return manageCellForIndexPath(for: indexPath)
    }
    
    func manageCellForIndexPath(for indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CityWeatherTableViewCell.nibName,
                                                           for: indexPath) as? CityWeatherTableViewCell
            else { return UITableViewCell() }
            guard let weather = presenter.weather else { return cell }
            cell.prepare(with: weather)
            return cell
        default:
            let attraction = presenter.attractions[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AttractionTableViewCell.nibName,
                                                           for: indexPath) as? AttractionTableViewCell
            else { return UITableViewCell() }
            cell.prepare(title: attraction.title, rate: String(format: "avg: %.2f", attraction.raiting))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
         return nil
        case 1:
            return "Weather for taday"
        case 2:
           return "Where to go?"
        default:
            return nil
        }
    }
}

extension CountryDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = CityImagesTableHeaderView.create()
            header?.prepare(with: presenter.cityImages)
            return header
        }
        return  UITableViewHeaderFooterView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard indexPath.section == 2 else {
            return
        }
        router.route(type: .map, from: self, with: presenter.attractions[indexPath.row])
    }
}

extension CountryDetailsViewController: CountryDetailsView {
    func showWeather(forecast: WeatherForecast) {
        tableView.reloadSections(IndexSet(integer: 1), with: .fade)
    }
    
    func showCityImages(from imageLinks: [CityImage]) {
        if let header = tableView.headerView(forSection: 0) as? CityImagesTableHeaderView {
            header.prepare(with: imageLinks)
        }
    }
    
    func showAttractions() {
        tableView.reloadSections(IndexSet(integer: 2), with: .fade)
        activityIndicator.stopAnimating()
    }
}
