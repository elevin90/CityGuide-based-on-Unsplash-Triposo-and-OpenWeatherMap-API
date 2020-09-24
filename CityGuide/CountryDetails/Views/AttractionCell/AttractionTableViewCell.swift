//
//  AttractionTableViewCell.swift
//  CityGuide
//
//  Created by Evgeniy Levin on 8/13/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import UIKit

class AttractionTableViewCell: UITableViewCell, NibLoadableView {
    
    @IBOutlet private weak var attractionTitleLabel: UILabel!
    @IBOutlet private weak var attractionRateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func prepare(title: String, rate: String) {
        attractionTitleLabel.text = title
        attractionRateLabel.text = rate
    }
}
