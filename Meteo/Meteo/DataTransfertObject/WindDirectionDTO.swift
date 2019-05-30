//
//  WindDirectionDTO.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation

struct WindDirectionDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case tenMeter = "10m"
    }

    let tenMeter: Double?
}
