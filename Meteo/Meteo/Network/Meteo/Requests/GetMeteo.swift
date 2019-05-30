//
//  GetMeteo.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation

enum GetMeteoError: Error {
    case bandwidthLimitExceed
    case badRequest
    case conflict
    case unknown

    init(with code: Int) {
        switch code {
        case 400:
            self = .badRequest
        case 409:
            self = .conflict
        case 509:
            self = .bandwidthLimitExceed
        default:
            self = .unknown
        }
    }

    init?(with meteoDTO: MeteoDTO) {
        switch meteoDTO.request_state {
        case 200:
            return nil
        case 400:
            self = .badRequest
        case 409:
            self = .conflict
        case 509:
            self = .bandwidthLimitExceed
        default:
            self = .unknown
        }
    }
}

struct GetMeteo: DecodableRequest {
    typealias ErrorType = GetMeteoError
    typealias DecodableType = MeteoDTO

    var dataTask: URLSessionDataTask?
    var endPoint: EndPointProtocol

    init(location: String) {
        self.endPoint = MeteoEndPoint.fromLocation(location: location)
    }

    static func error(from response: HTTPURLResponse?) -> GetMeteoError {
        guard let statusCode = response?.statusCode else {
            return GetMeteoError.unknown
        }

        return GetMeteoError(with: statusCode)
    }

    static func error(from decodedObject: DecodableType) -> ErrorType? {
        return GetMeteoError(with: decodedObject)
    }
}
