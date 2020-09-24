//
//  SavedRegion+CoreDataProperties.swift
//  CityGuide
//
//  Created by Evgeniy Levin on 8/14/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedRegion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedRegion> {
        return NSFetchRequest<SavedRegion>(entityName: "SavedRegion")
    }

    @NSManaged public var imageData: NSData?
    @NSManaged public var title: String?
    @NSManaged public var imageName: String?
    @NSManaged public var countries: NSSet?

}

// MARK: Generated accessors for countries
extension SavedRegion {

    @objc(addCountriesObject:)
    @NSManaged public func addToCountries(_ value: SavedCountry)

    @objc(removeCountriesObject:)
    @NSManaged public func removeFromCountries(_ value: SavedCountry)

    @objc(addCountries:)
    @NSManaged public func addToCountries(_ values: NSSet)

    @objc(removeCountries:)
    @NSManaged public func removeFromCountries(_ values: NSSet)

}
