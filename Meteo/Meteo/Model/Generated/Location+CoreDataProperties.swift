//
//  Location+CoreDataProperties.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var a_latitude: Double
    @NSManaged public var a_longitude: Double
    @NSManaged public var is_current_location: Bool
    @NSManaged public var r_localisation: NSSet?

}

// MARK: Generated accessors for r_localisation
extension Location {

    @objc(addR_localisationObject:)
    @NSManaged public func addToR_localisation(_ value: Forecast)

    @objc(removeR_localisationObject:)
    @NSManaged public func removeFromR_localisation(_ value: Forecast)

    @objc(addR_localisation:)
    @NSManaged public func addToR_localisation(_ values: NSSet)

    @objc(removeR_localisation:)
    @NSManaged public func removeFromR_localisation(_ values: NSSet)

}
