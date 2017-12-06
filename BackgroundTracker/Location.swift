//
//  Location.swift
//  BackgroundTracker
//
//  Created by Maxim Tovchenko on 06.12.2017.
//  Copyright © 2017 Maxim Tovchenko. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationModel {
    var date: NSDate
    var coordinate: Coorditate2D
}

struct Coorditate2D {
    var latitude: Double
    var longitude: Double
}
