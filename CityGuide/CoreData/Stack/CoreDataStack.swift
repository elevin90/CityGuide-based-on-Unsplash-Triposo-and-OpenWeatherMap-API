//
//  CoreDataStack.swift
//  WeatherLocation
//
//  Created by Evgeniy Levin on 8/9/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataRequestType {
    case region
    case country
    case attraction
}

final class CoreDataStack {
    
    static let shared = CoreDataStack()

    
    private let modelName: String
    
    private init() {
        self.modelName = "CityGuide"
    }
    
    private lazy var storageURL: URL? = {
        let path = "\(modelName).sqlite"
        var documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return documentDirectory?.appendingPathComponent(path)
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Database file not found")
        }
        guard let managedModel =  NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error in DB deserialization")
        }
        return  managedModel
    }()
    
    private lazy var storeCoordinator : NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            let coordinatorOptions = [
                NSInferMappingModelAutomaticallyOption : true,
                NSMigratePersistentStoresAutomaticallyOption : true
            ]
            
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: self.storageURL, options: coordinatorOptions)
            
        } catch {
            print(error)
        }
       return coordinator
    }()
    
    private lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = self.backgroundContext
        return context
    }()
    
    private lazy var backgroundContext: NSManagedObjectContext = {
       let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.storeCoordinator
        return context
    }()
    
    private func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(onNotification), name: Notification.Name.NSExtensionHostDidEnterBackground, object: nil)
    }
    
    @objc private func onNotification(notification: NSNotification) {
        
    }
    
    private func getRequestWithType(type: CoreDataRequestType) -> NSFetchRequest<NSFetchRequestResult> {
        switch type {
        case .attraction:
              return SavedAttraction.fetchRequest()
        case .country:
            return SavedCountry.fetchRequest()
        case .region:
            return SavedRegion.fetchRequest()
        }
    }
    
    public func save(_ object: NSManagedObject) {
        mainContext.performAndWait {[weak self] in
            guard let welf = self else { return }
            if welf.mainContext.hasChanges {
                do { try welf.mainContext.save() }
                catch { print(error as NSError)  }
            }
            
            if welf.backgroundContext.hasChanges {
                do { try welf.backgroundContext.save() }
                catch { print(error as NSError) }
            }
        }
    }
    
    public func clearAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedRegion")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try mainContext.execute(batchDeleteRequest)
            try backgroundContext.execute(batchDeleteRequest)
        } catch {
           print(error.localizedDescription)
        }
    }
    
    public func getall(type: CoreDataRequestType) -> [NSManagedObject]? {
        do {
            return try backgroundContext.fetch(getRequestWithType(type: type)) as? [NSManagedObject]
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    public func saveNew(region: Region) {
        let savedRegion = SavedRegion(context: backgroundContext)
        savedRegion.title = region.title
        savedRegion.imageData = region.imageTitle.pngImageData() as NSData?
        savedRegion.imageName = region.imageTitle
        for country in region.countries {
            let savedCountry = SavedCountry(context: backgroundContext)
            savedCountry.title = country.title
            savedCountry.capital = country.capital
            savedRegion.addToCountries(savedCountry)
        }
        save(savedRegion)
    }
    
    public func saveAttractions(attractions: [Attraction], savedCountry: SavedCountry) {
        for attraction in attractions {
            let savedAttraction = SavedAttraction(context: backgroundContext)
            savedAttraction.title = attraction.title
            savedAttraction.raiting = attraction.raiting
            savedAttraction.latitude = attraction.location.latitude
            savedAttraction.longtitude = attraction.location.longitude
            savedCountry.addToAttractions(savedAttraction)
            savedAttraction.country = savedCountry
            save(savedAttraction)
        }
    }
}
