//
//  MeteoEndPoint.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation

enum MeteoEndPoint: EndPointProtocol {
    case fromLocation(location: String)

    var method: Method {
        switch self {
        case .fromLocation:
            return .get
        }
    }

    var endPoint: String {
        switch self {
        case .fromLocation(let location):
            return #"json?_ll=\#(location)&_auth=\#(MeteoConstants.auth)&_c=\#(MeteoConstants.cParameter)"#
        }
    }
}
