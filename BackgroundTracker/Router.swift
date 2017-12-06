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
}

class Router: RouterProtocol {
    
    var window: UIWindow?
    private var startViewController: UIViewController?
    
    func presentStartView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let startView = storyboard.instantiateViewController(withIdentifier: "locationsTableViewControllerID") as! LocationTableViewControllerProtocol
        let presenter = Presenter()
        startView.presenter = presenter
        presenter.view = startView
        let interactor = LocationInteractor()
        presenter.interactor = interactor
        interactor.coreDataManager = CoreDataManager.shared
        interactor.presenter = presenter
        self.window?.rootViewController = startView as! UIViewController
        interactor.startGeotracking()
    }
}
