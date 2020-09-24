//
//  RegionHeaderView.swift
//  CityGuide
//
//  Created by Evgeniy Levin on 8/12/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import UIKit

class RegionHeaderView: UITableViewHeaderFooterView, NibLoadableView {

    @IBOutlet private weak var regionTitleLabel: UILabel!
    @IBOutlet private weak var regionImage: UIImageView!
    
    static func create() -> RegionHeaderView? {
        return Bundle.main.loadNibNamed(RegionHeaderView.nibName, owner: nil, options: nil)?.first as? RegionHeaderView
    }
    
    func prepare(with title: String, image: UIImage?) {
        regionTitleLabel.text = title
        regionImage.image = image
    }
}
