//
//  File.swift
//  WeatherLocation
//
//  Created by Evgeniy Levin on 7/30/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import UIKit

extension String {
    var firstUppercased: String {
        let lowerCasedString = lowercased()
        guard let first = lowerCasedString.first else { return "" }
        return String(first).uppercased() + lowerCasedString.dropFirst()
    }
    
    func pngImageData() -> Data? {
        let imageTitle = self
        let image = UIImage(named: imageTitle)
        return image?.pngData()
    }
}
