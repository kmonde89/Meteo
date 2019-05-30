//
//  CloudinessDTO.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation

struct CloudinessDTO: Decodable {
    let totale: Double?
    let haute: Double?
    let moyenne: Double?
    let basse: Double?
}
