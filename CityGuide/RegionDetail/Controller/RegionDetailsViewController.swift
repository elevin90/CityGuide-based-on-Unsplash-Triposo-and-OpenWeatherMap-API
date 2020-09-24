//
//  RegionDetailsViewController.swift
//  CityGuide
//
//  Created by Evgeniy Levin on 8/11/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import UIKit

class RegionDetailsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private let presenter: RegionDetailsPresenting
    private let router: AppRouting
    
    init(with presenter: RegionDetailsPresenter) {
        self.presenter = presenter
        self.router = AppRouter()
        super.init(nibName: "RegionDetailsViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor.appColor(.background)
        let nib = UINib(nibName: CountryTableViewCell.nibName, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: CountryTableViewCell.nibName)
        tableView.register(RegionHeaderView.self, forHeaderFooterViewReuseIdentifier: RegionHeaderView.nibName)
        tableView.dataSource = self
        tableView.delegate = self
        let searchVC = UISearchController(searchResultsController: nil)
        searchVC.searchResultsUpdater = self
        searchVC.delegate = self
        navigationItem.searchController = searchVC
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = presenter.regionTitle
        navigationItem.hidesSearchBarWhenScrolling = true
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 50
        tableView.reloadData()
        tableView.backgroundColor = UIColor.appColor(.background)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "left-arrow"), style: .plain, target: self, action: #selector(onBack))
    }
    
    @objc private func onBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension RegionDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.countriesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let countryCell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.nibName, for: indexPath) as? CountryTableViewCell
        let country = presenter.country(at: indexPath)
        countryCell?.prepare(with: country.title, capital: country.capital)
        return countryCell ?? UITableViewCell()
    }
}

extension RegionDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = RegionHeaderView.create()
        header?.prepare(with: presenter.regionTitle, image: UIImage(named: presenter.imageTitle))
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let sellectedCountry = presenter.country(at: indexPath)
        router.route(type: .countryDetails, from: self, with: sellectedCountry)
    }
}

extension RegionDetailsViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        presenter.filterCountries(searchText: searchController.searchBar.text ?? "") {[weak self] in
            self?.tableView.reloadData()
        }
    }
}
