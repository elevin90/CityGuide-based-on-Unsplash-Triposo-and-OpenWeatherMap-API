//
//  CountryTableViewCell.swift
//  CityGuide
//
//  Created by Evgeniy Levin on 8/12/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import UIKit
import WebKit

class CountryTableViewCell: UITableViewCell, NibLoadableView {

    @IBOutlet private weak var capitalLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private let cache = NSCache<NSString, UIImage>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
    }
    
    func prepare(with title: String, capital: String) {
        titleLabel.text = title
        capitalLabel.text = capital
    }
}



//extension CountryTableViewCell {
//    private func manageImage(with url: URL)  {
//        flagImageView.image = nil
//        if let image = cache.object(forKey: url.absoluteString as NSString) {
//            DispatchQueue.main.async { [weak self] in
//                self?.flagImageView.image = image
//                return
//            }
//        } else {
//            URLSession.shared.dataTask(with: url) { (data, _, error) in
//                if error != nil { return }
//                if let _data = data { //let image = UIImage(data: _data) {
//                    DispatchQueue.main.async { [weak self] in
//                        print(url)
//                        //self?.flagImageView.image = image
//                      //  self?.cache.setObject(image, forKey: url.absoluteString as NSString)
//                    }
//                }
//            }.resume()
//        }
//    }
//}
