//
//  LocationsManager.swift
//  BackgroundTracker
//
//  Created by Maxim Tovchenko on 05.12.2017.
//  Copyright © 2017 Maxim Tovchenko. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

protocol CoreDataLocationFacadeProtocol {
    static func getLocations() -> [CLLocation]
    static func deleteAllLocations()
    static func deleteLocationWith(date: Date)
    static func addNew(location: CLLocation, withDate date: NSDate)
}

class CoreDataLocationFacade: CoreDataLocationFacadeProtocol -> [CLLocation] {
    static func getLocations() -> [CLLocation] {
        var locations = [CLLocation]()
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fr: NSFetchRequest<Location> = Location.fetchRequest()
        fr.sortDescriptors = [NSSortDescriptor.init(key: "date", ascending: true)]
        
        do {
            let locationsDB = try context.fetch(fr)
            locationsDB.forEach({ (locDB) in
                let location = CLLocation(
            })
        } catch {
            print("Ooops.")
        }
        return locations
    }
    
    static func deleteAllLocations() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fr: NSFetchRequest<Location> = Location.fetchRequest()
        fr.sortDescriptors = [NSSortDescriptor.init(key: "date", ascending: true)]
        
        do {
            let locations = try context.fetch(fr)
            locations.forEach { (location) in
                context.delete(location)
            }
            CoreDataManager.shared.saveContext()
        } catch {
            print("Ooops.")
        }
    }
    
    static func delete(location locForDelete: CLLocation, withDate date: Date) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fr: NSFetchRequest<Location> = Location.fetchRequest()
        let predicate = NSPredicate(format: "date == %@ AND longtitude == %@ AND latitude == %@", date as NSDate, locForDelete.coordinate.longitude, locForDelete.coordinate.latitude)
        fr.predicate = predicate
        do {
            let locations = try context.fetch(fr)
            locations.forEach({ (location) in
                context.delete(location)
            })
            CoreDataManager.shared.saveContext()
        } catch {
            print("Ooops.")
        }
    }
    
    static func addNew(location: CLLocation, withDate date: NSDate) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let ed = NSEntityDescription.entity(forEntityName: "Location", in: context)
        let locationDB = Location(entity: ed!, insertInto: context)
        locationDB.date = date as NSDate
        locationDB.latitude = location.coordinate.latitude
        locationDB.longitude = location.coordinate.longitude
    }
    

}
