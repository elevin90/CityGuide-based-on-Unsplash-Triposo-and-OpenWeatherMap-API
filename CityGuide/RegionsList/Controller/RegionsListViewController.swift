//
//  ViewController.swift
//  CityGuide
//
//  Created by Evgeniy Levin on 8/9/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import UIKit

protocol RegionsListView: AnyObject {
    func showRegions(_ regions: [Region])
    func showError(message: String)
}

class RegionsListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var presenter: RegionsListPresenting
    private let router: AppRouting
    
    required init?(coder aDecoder: NSCoder) {
        presenter = RegionsListPresenter()
        router = AppRouter()
        super.init(coder: aDecoder)
    }

    private lazy var collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 350)
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.view = self
        presenter.loadCountries()
    }
    
    private func setupUI() {
        collectionView.collectionViewLayout = collectionLayout
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Regions"
        navigationController?.navigationBar.backgroundColor = UIColor.appColor(.background)
        view.backgroundColor = UIColor.appColor(.background)
        let cellNib = UINib(nibName: RegionCell.cellID, bundle: Bundle.main)
        collectionView.register(cellNib, forCellWithReuseIdentifier: RegionCell.cellID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.appColor(.cell)
    }
}

extension RegionsListViewController: RegionsListView {
    func showRegions(_ regions: [Region]) {
        collectionView.reloadData()
    }
    
    func showError(message: String) {
        router.showError(title: "No internet connection",
                         message: "The app requiers internet connection on first launch", from: self)
    }
}

extension RegionsListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.regionsCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegionCell.cellID,
                                                            for: indexPath) as? RegionCell
        else { return UICollectionViewCell() }
        cell.fill(with: presenter.region(at: indexPath.row))
        return cell
    }
}

extension RegionsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RegionCell else { return }
        let region = self.presenter.region(at: indexPath.row)
        cell.bounceCompletion = {[weak self] in
            guard let welf = self else { return  }
            welf.router.route(type: .regionDetails, from: welf, with: region)
        }
        cell.bounceOnSelection()
    }
}
