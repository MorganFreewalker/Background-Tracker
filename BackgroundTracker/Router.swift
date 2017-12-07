//
//  Router.swift
//  BackgroundTracker
//
//  Created by Maxim Tovchenko on 06.12.2017.
//  Copyright © 2017 Maxim Tovchenko. All rights reserved.
//

import Foundation
import UIKit

protocol RouterProtocol {
    var window: UIWindow? {get set}
    func presentStartView()
    func presentMapView()
}

class Router: RouterProtocol {
    
    var window: UIWindow?
    private var startViewController: UIViewController?
    
    func presentStartView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var startViewController = storyboard.instantiateViewController(withIdentifier: "locationsListViewControllerID") as! LocationTableViewControllerProtocol
        let presenter = Presenter()
        startViewController.presenter = presenter
        presenter.view = startViewController
        presenter.router = self
        let interactor = LocationInteractor()
        let locationManager = LocationManager()
        presenter.interactor = interactor
        interactor.coreDataManager = CoreDataManager.shared
        interactor.locationManager = locationManager
        interactor.presenter = presenter
        locationManager.interactor = interactor
        self.window?.rootViewController = startViewController as? UIViewController
    }
    
    func presentMapView() {
        return
    }
}
