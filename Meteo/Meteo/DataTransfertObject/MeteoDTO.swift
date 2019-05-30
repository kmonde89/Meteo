//
//  MeteoDTO.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation

struct MeteoDTO: Decodable {
    enum CodingKeys: CodingKey {
        case request_state
        case request_key
        case message
        case model_run
        case source
        case forecastElement(key: String)

        var isForecastElement: Bool {
            switch self {
            case .forecastElement:
                return true
            default:
                return false
            }
        }

        var stringValue: String {
            switch self {
            case .request_state: return "request_state"
            case .request_key: return "request_key"
            case .message: return "message"
            case .model_run: return "model_run"
            case .source: return "source"
            case .forecastElement(let date): return "\(date)"
            }
        }

        var intValue: Int? {
            return nil
        }

        init?(stringValue key: String) {
            switch key {
            case "request_state":
                self = .request_state
            case "request_key":
                self = .request_key
            case "message":
                self = .message
            case "model_run":
                self = .model_run
            case "source":
                self = .source
            default:
                self = .forecastElement(key: key)
            }
        }

        init?(intValue: Int) {
            return nil
        }
    }

    let request_state: Int
    let request_key: String
    let message: String
    let model_run: String
    let source: String
    let forecast: [ForecastDTO]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.request_state = try container.decode(Int.self, forKey: .request_state)
        self.request_key = try container.decode(String.self, forKey: .request_key)
        self.message = try container.decode(String.self, forKey: .message)
        self.model_run = try container.decode(String.self, forKey: .model_run)
        self.source = try container.decode(String.self, forKey: .source)
        self.forecast = container.allKeys.filter({ $0.isForecastElement }).compactMap({
            try? container.decode(ForecastDTO.self, forKey: $0)
        })
    }
}
