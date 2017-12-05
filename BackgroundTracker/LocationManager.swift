//
//  LocationManager.swift
//  BackgroundTracker
//
//  Created by Maxim Tovchenko on 05.12.2017.
//  Copyright © 2017 Maxim Tovchenko. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var delegate: LocationManagerDelegate
    
    var cl = CLLocationManager()
    
    override init(){
        super.init()
        self.cl = CLLocationManager()
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            cl.delegate = self.delegate
            cl.allowsBackgroundLocationUpdates = true
            print(cl.pausesLocationUpdatesAutomatically)
            cl.pausesLocationUpdatesAutomatically = false
            cl.allowDeferredLocationUpdates(untilTraveled: CLLocationDistance.init(100), timeout: TimeInterval.init(60))
            cl.startUpdatingLocation()
            cl.startMonitoringSignificantLocationChanges()
        } else {
            cl.requestAlwaysAuthorization()
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let ed = NSEntityDescription.entity(forEntityName: "Location", in: context)
        locations.forEach { (location) in
            let locationBase = Location(entity: ed!, insertInto: context)
            locationBase.date = location.timestamp as NSDate
            locationBase.longitude = location.coordinate.longitude
            locationBase.latitude = location.coordinate.latitude
        }
        try! context.save()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            cl.delegate = self
            cl.allowsBackgroundLocationUpdates = true
            cl.pausesLocationUpdatesAutomatically = false
            cl.allowDeferredLocationUpdates(untilTraveled: CLLocationDistance.init(100), timeout: TimeInterval.init(60))
            cl.startUpdatingLocation()
            cl.startMonitoringSignificantLocationChanges()
        }
    }
}

protocol LocationManagerDelegate: CLLocationManagerDelegate {
    func updateScreen()
    
}
