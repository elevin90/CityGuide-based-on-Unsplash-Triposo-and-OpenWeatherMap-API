//
//  SavedCountry+CoreDataProperties.swift
//  CityGuide
//
//  Created by Evgeniy Levin on 8/14/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedCountry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedCountry> {
        return NSFetchRequest<SavedCountry>(entityName: "SavedCountry")
    }

    @NSManaged public var capital: String?
    @NSManaged public var title: String?
    @NSManaged public var attractions: NSSet?
    @NSManaged public var country: SavedRegion?

}

// MARK: Generated accessors for attractions
extension SavedCountry {

    @objc(addAttractionsObject:)
    @NSManaged public func addToAttractions(_ value: SavedAttraction)

    @objc(removeAttractionsObject:)
    @NSManaged public func removeFromAttractions(_ value: SavedAttraction)

    @objc(addAttractions:)
    @NSManaged public func addToAttractions(_ values: NSSet)

    @objc(removeAttractions:)
    @NSManaged public func removeFromAttractions(_ values: NSSet)

}
