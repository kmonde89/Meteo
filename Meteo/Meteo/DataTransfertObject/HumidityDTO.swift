//
//  HumidityDTO.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation

struct HumidityDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case twoMeter = "2m"
    }

    let twoMeter: Double?
}
