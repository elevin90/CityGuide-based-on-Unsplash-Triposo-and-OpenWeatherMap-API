//
//  SavedAttraction+CoreDataProperties.swift
//  CityGuide
//
//  Created by Evgeniy Levin on 8/14/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//
//

import Foundation
import CoreData

extension SavedAttraction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedAttraction> {
        return NSFetchRequest<SavedAttraction>(entityName: "SavedAttraction")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longtitude: Double
    @NSManaged public var raiting: Double
    @NSManaged public var title: String?
    @NSManaged public var country: SavedCountry?
}
