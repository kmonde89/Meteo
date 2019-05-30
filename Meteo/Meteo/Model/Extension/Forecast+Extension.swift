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
}
