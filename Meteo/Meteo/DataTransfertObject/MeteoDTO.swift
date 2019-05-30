//
//  MeteoDTO.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation

struct MeteoDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case request_state
        case request_key
        case message
        case model_run
        case source
    }

    let request_state: Int
    let request_key: String
    let message: String
    let model_run: String
    let source: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.request_state = try container.decode(Int.self, forKey: .request_state)
        self.request_key = try container.decode(String.self, forKey: .request_key)
        self.message = try container.decode(String.self, forKey: .message)
        self.model_run = try container.decode(String.self, forKey: .model_run)
        self.source = try container.decode(String.self, forKey: .source)
    }
}
