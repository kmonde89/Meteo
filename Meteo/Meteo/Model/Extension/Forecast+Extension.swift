//
//  Forecast+Extension.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

extension Forecast {
    @nonobjc public class func fetchRequestCurrentLocationForecast() -> NSFetchRequest<Forecast> {
        let fetchRequest = NSFetchRequest<Forecast>(entityName: "Forecast")

        fetchRequest.predicate = NSPredicate(format: "a_date >= %@", NSDate())
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "a_date", ascending: true)]
        return fetchRequest
    }

    var windSpeed: Measurement<Unit> {
        return Measurement(value: self.a_windSpeed, unit: UnitSpeed.kilometersPerHour)
    }

    var windDirection: Measurement<Unit> {
        return Measurement(value: self.a_windDirection, unit: Unit(symbol: "°"))
    }

    var humidity: Measurement<Unit> {
        return Measurement(value: self.a_humidity, unit: Unit(symbol: "%"))
    }

    var temperature: Measurement<Unit> {
        return Measurement(value: self.a_humidity, unit: Unit(symbol: "Kelvin"))
    }

    var cloudiness: Measurement<Unit> {
        return Measurement(value: self.a_humidity, unit: Unit(symbol: "%"))
    }
}
