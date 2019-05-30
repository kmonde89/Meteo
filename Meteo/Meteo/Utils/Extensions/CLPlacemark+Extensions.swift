//
//  CLPlacemark+Extensions.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation
import CoreLocation

extension CLPlacemark {
    var placeName: String {
        return [self.locality, self.administrativeArea, self.country].compactMap({$0}).joined(separator: ", ")
    }
}
