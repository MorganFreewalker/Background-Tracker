//
//  Presenter.swift
//  BackgroundTracker
//
//  Created by Maxim Tovchenko on 06.12.2017.
//  Copyright © 2017 Maxim Tovchenko. All rights reserved.
//

import Foundation
import UIKit

protocol PresenterProtocol {
    var view: LocationTableViewControllerProtocol? {get set}
    var interactor: LocationInteractor? {get set}
    var router: RouterProtocol? {get set}
    var canDeleteCell: Bool {get}

    func didLoadView()
    func numberOfRowAt(section: Int) -> Int
    func deleteRowsAt(indexPath: [IndexPath])
    func locationForCellAt(indexPath: IndexPath) -> LocationModel
    func updateScreen()
    func startButtonPressed()
    func stopButtonPressed()
    func dropDBButtonPressed()
    func mapButtonPressed()
}

class Presenter: PresenterProtocol {
    
    var router: RouterProtocol?
    var view: LocationTableViewControllerProtocol?
    var interactor: LocationInteractor?
    
    var canDeleteCell: Bool = false
    
    func mapButtonPressed() {
        self.router?.presentMapView()
    }
    
    func updateScreen(){
        self.view?.updateScreen()
    }
    
    func startButtonPressed() {
        self.interactor?.startGeotracking()
    }
    
    func stopButtonPressed() {
        self.interactor?.stopGeotracking()
    }
    
    func dropDBButtonPressed() {
        self.interactor?.deleteAllLocations()
    }
    

    func locationForCellAt(indexPath: IndexPath) -> LocationModel {
        let locations = interactor?.getLocations()
        if let location = locations?[indexPath.row] {
            return location
        } else {
            return LocationModel(date: NSDate(), coordinate: Coorditate2D(latitude: 0, longitude: 0))
        }
    }
    
    func didLoadView() {
        view?.updateScreen()
    }
    
    func numberOfRowAt(section: Int) -> Int {
        return interactor?.getLocations().count ?? 0
    }
    
    func deleteRowsAt(indexPath: [IndexPath]) {
        if let locations = interactor?.getLocations() {
            indexPath.forEach({ (indPath) in
                interactor?.delete(location: locations[indPath.row])
            })
        }
    }
}
