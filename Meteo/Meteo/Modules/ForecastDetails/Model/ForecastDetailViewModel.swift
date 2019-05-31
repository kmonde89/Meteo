//
//  ForecastDetailViewModel.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation

class ForecastDetailViewModel {
    private var forecast: Forecast
    private var formatter: MeasurementFormatter

    init(with forecast: Forecast) {
        self.forecast = forecast
        self.formatter = MeasurementFormatter()
        formatter.unitStyle = .short
    }

    var date: Date? {
        return forecast.a_date as Date?
    }

    var windSpeed: String {
        return "\("windSpeed".localizedString) : \(formatter.string(from: forecast.windSpeed))"
    }

    var windDirection: String {
        return "\("windDirection".localizedString) : \(formatter.string(from: forecast.windDirection))"
    }

    var humidity: String {
        return "\("humidity".localizedString) : \(formatter.string(from: forecast.humidity))"
    }

    var temperature: String {
        return "\("temperature".localizedString) : \(formatter.string(from: forecast.temperature))"
    }

    var cloudiness: String {
        return "\("cloudiness".localizedString) : \(formatter.string(from: forecast.cloudiness))"
    }
}
