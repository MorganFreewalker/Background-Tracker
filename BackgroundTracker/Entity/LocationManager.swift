//
//  LocationManager.swift
//  BackgroundTracker
//
//  Created by Maxim Tovchenko on 05.12.2017.
//  Copyright © 2017 Maxim Tovchenko. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerProtocol: CLLocationManagerDelegate {
    var interactor: LocationInteractorProtocol? {get set}
    
    func stopGeotracking()
    func startGeotracking()
}

class LocationManager: NSObject, LocationManagerProtocol {
    
    var interactor: LocationInteractorProtocol?
    
    var cl = CLLocationManager()
    
    override init(){
        super.init()
        self.cl = CLLocationManager()
        self.cl.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            cl.allowsBackgroundLocationUpdates = true
            cl.pausesLocationUpdatesAutomatically = false
            cl.allowDeferredLocationUpdates(untilTraveled: CLLocationDistance.init(100), timeout: TimeInterval.init(60))
        } else {
            cl.requestAlwaysAuthorization()
        }

    }
    
    func startGeotracking() {
        self.cl.startUpdatingLocation()
        self.cl.startMonitoringSignificantLocationChanges()
    }
    
    func stopGeotracking() {
        self.cl.stopUpdatingLocation()
        self.cl.stopMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach { (location) in
            let locationModel = LocationModel(date: location.timestamp as NSDate, coordinate: Coorditate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            self.interactor?.addNew(location: locationModel)
        }
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
