//
//  LocationsManager.swift
//  BackgroundTracker
//
//  Created by Maxim Tovchenko on 05.12.2017.
//  Copyright © 2017 Maxim Tovchenko. All rights reserved.
//

import Foundation
import CoreData

protocol LocationInteractorProtocol {
    var presenter: PresenterProtocol? {get set}
    var locationManager: LocationManagerProtocol? {get set}
    var coreDataManager: CoreDataManagerProtocol? {get set}
    
    func getLocations() -> [LocationModel]
    func deleteAllLocations()
    func delete(location: LocationModel)
    func addNew(location: LocationModel)
    func startGeotracking()
    func stopGeotracking()
}

class LocationInteractor: LocationInteractorProtocol {
    var locationManager: LocationManagerProtocol?
    var coreDataManager: CoreDataManagerProtocol?
    var presenter: PresenterProtocol?
    
    func startGeotracking() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateScreenSelector), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
        locationManager?.startGeotracking()
    }
    
    func stopGeotracking() {
        locationManager?.stopGeotracking()
    }
    
    @objc func updateScreenSelector(){
        self.presenter?.updateScreen()
    }
    
    func getLocations() -> [LocationModel] {
        var locations = [LocationModel]()
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fr: NSFetchRequest<Location> = Location.fetchRequest()
        fr.sortDescriptors = [NSSortDescriptor.init(key: "date", ascending: true)]
        
        do {
            let locationsDB = try context.fetch(fr)
            locationsDB.forEach({ (locDB) in
                let location = LocationModel(date: locDB.date!, coordinate: Coorditate2D(latitude: locDB.latitude, longitude: locDB.longitude))
                locations.append(location)
            })
        } catch {
            print("Ooops.")
        }
        return locations
    }
    
    func deleteAllLocations() {
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
    
    func delete(location locForDelete: LocationModel) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fr: NSFetchRequest<Location> = Location.fetchRequest()
        let predicate = NSPredicate(format: "date == %@ AND longtitude == %@ AND latitude == %@", locForDelete.date as NSDate, locForDelete.coordinate.longitude, locForDelete.coordinate.latitude)
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
    
    func addNew(location: LocationModel) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let ed = NSEntityDescription.entity(forEntityName: "Location", in: context)
        let locationDB = Location(entity: ed!, insertInto: context)
        locationDB.date = location.date
        locationDB.latitude = location.coordinate.latitude
        locationDB.longitude = location.coordinate.longitude
    }
    
    
}
