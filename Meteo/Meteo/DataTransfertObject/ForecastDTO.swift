//
//  ForecastDTO.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation

struct ForecastDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case cloudiness = "nebulosite"
        case temperature
        case windSpeed = "vent_moyen"
        case windDirection = "vent_direction"
        case humidity = "humidite"
    }

    let date: Date
    let cloudiness: CloudinessDTO
    let temperature: TemperatureDTO
    let windSpeed: WindSpeedDTO
    let windDirection: WindDirectionDTO
    let humidity: HumidityDTO

    init(from decoder: Decoder) throws {
        guard let dateString = decoder.codingPath.last?.stringValue else {
            throw DecodingError.unreachableCodingPathKey
        }

        guard let date = DateFormatter.forecastDateFormatter.date(from: dateString) else {
            throw DecodingError.undecodableForecastDate
        }

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.date = date
        self.cloudiness = try container.decode(CloudinessDTO.self, forKey: .cloudiness)

        self.temperature = try container.decode(TemperatureDTO.self, forKey: .temperature)
        self.windSpeed = try container.decode(WindSpeedDTO.self, forKey: .windSpeed)
        self.windDirection = try container.decode(WindDirectionDTO.self, forKey: .windDirection)
        self.humidity = try container.decode(HumidityDTO.self, forKey: .humidity)
    }
}
