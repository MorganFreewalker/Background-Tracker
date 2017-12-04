//
//  Location+CoreDataProperties.swift
//  BackgroundTracker
//
//  Created by Maxim Tovchenko on 04.12.2017.
//  Copyright © 2017 Maxim Tovchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var date: NSDate?

}
