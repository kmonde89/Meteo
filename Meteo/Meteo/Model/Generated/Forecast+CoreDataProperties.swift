//
//  Forecast+CoreDataProperties.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//
//

import Foundation
import CoreData


extension Forecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Forecast> {
        return NSFetchRequest<Forecast>(entityName: "Forecast")
    }

    @NSManaged public var a_cloudiness: Double
    @NSManaged public var a_date: NSDate?
    @NSManaged public var a_humidity: Double
    @NSManaged public var a_temperature: Double
    @NSManaged public var a_windDirection: Double
    @NSManaged public var a_windSpeed: Double
    @NSManaged public var r_forecasts: Location?

}
