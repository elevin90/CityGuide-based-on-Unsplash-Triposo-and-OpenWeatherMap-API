//
//  CityImagesTableHeaderView.swift
//  CityGuide
//
//  Created by Evgeniy Levin on 8/13/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import UIKit

class CityImagesTableHeaderView: UITableViewHeaderFooterView, NibLoadableView {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet private weak var mainImage: UIImageView!
    @IBOutlet private var images: [UIImageView]!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var defaultImage: UIImageView!
    
    private let cache = NSCache<NSString, UIImage>()
    
    static func create() -> CityImagesTableHeaderView? {
        return Bundle.main.loadNibNamed(CityImagesTableHeaderView.nibName, owner: nil, options: nil)?.first as? CityImagesTableHeaderView
    }
    
    func prepare(with cityImages: [CityImage]) {
        if !Reachability.isConnectedToNetwork() || cityImages.count <= 5 {
            manageOfflineImages()
            return
        }
        for (index,image) in cityImages.enumerated() {
            guard images.count > index, let url = URL(string: image.urls.link) else {
                return
            }
            setupGradient()
            errorLabel.isHidden = true
            defaultImage.isHidden = true
            manageImage(with: url, imageView: images[index])
        }
    }
    
    private func setupGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = gradientView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.1).cgColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
        bringSubviewToFront(gradientView)
    }
}

extension CityImagesTableHeaderView {
    private func manageImage(with url: URL, imageView: UIImageView)  {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async {
                imageView.image = image
                return
            }
        } else {
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if error != nil { return }
                if let _data = data, let image = UIImage(data: _data) {
                    DispatchQueue.main.async { [weak self] in
                        print(url)
                        imageView.image = image
                        self?.cache.setObject(image, forKey: url.absoluteString as NSString)
                    }
                }
            }.resume()
        }
    }
    
    private func manageOfflineImages() {
        bringSubviewToFront(gradientView)
        defaultImage.isHidden = false
        errorLabel.isHidden = false
    }
}
