//
//  Location+Extension.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

extension Location {
    @nonobjc public class func fetchRequestCurrentLocation() -> NSFetchRequest<Location> {
        let fetchRequest = NSFetchRequest<Location>(entityName: "Location")

        fetchRequest.predicate = NSPredicate(format: "is_current_location == YES")
        return fetchRequest
    }
    

}
