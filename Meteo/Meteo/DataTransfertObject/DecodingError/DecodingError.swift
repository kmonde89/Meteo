//
//  DecodingError.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation

enum DecodingError: Error {
    case unreachableCodingPathKey
    case undecodableForecastDate
}
