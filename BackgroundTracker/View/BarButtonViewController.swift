//
//  BarButtonViewController.swift
//  BackgroundTracker
//
//  Created by Maxim Tovchenko on 07.12.2017.
//  Copyright © 2017 Maxim Tovchenko. All rights reserved.
//

import UIKit

protocol BarButtonViewProtocol {
    var delegate: BarButtonViewDelegate? {get set}
}

class BarButtonViewController: UIViewController, BarButtonViewProtocol {
    var delegate: BarButtonViewDelegate?
    
    @IBAction func startButton(_ sender: Any) {
        delegate?.startButtonPressed()
    }
    
    @IBAction func stopButton(_ sender: Any) {
        delegate?.stopButtonPressed()
    }
    
    @IBAction func mapButton(_ sender: Any) {
        delegate?.mapButtonPressed()
    }
    
    @IBAction func dropDBButton(_ sender: Any) {
        delegate?.dropDBButtonPressed()
    }
}
