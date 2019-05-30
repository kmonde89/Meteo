//
//  DecodableRequestProtocol.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation

protocol DecodableRequest {
    associatedtype DecodableType : Decodable
    associatedtype ErrorType: Error

    var dataTask: URLSessionDataTask? {get set}
    var endPoint: EndPointProtocol {get}
    static func error(from response: HTTPURLResponse?) -> ErrorType
    static func error(from decodedObject: DecodableType) -> ErrorType?
}

extension DecodableRequest {
    mutating func performRequest(block: @escaping (_ result: Result<DecodableType, ErrorType>) -> Void) {
        guard let dataTask = self.dataTask else {
            self.subPerformRequest(block: block)
            return
        }

        switch dataTask.state {
        case .suspended:
            dataTask.resume()
        case .canceling, .completed:
            self.subPerformRequest(block: block)
        case .running:
            break
        @unknown default:
            fatalError()
        }

    }

    fileprivate mutating func subPerformRequest(block: @escaping (_ result: Result<DecodableType, ErrorType>) -> Void) {
        guard let urlRequest = self.endPoint.getURLRequest() else {
            return
        }

        self.dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                
                do {
                    let decodableDTO = try decoder.decode(DecodableType.self, from: data)
                    DispatchQueue.main.async {
                        if let error = Self.error(from: decodableDTO) {
                            block(.failure(error))
                        } else {
                            block(.success(decodableDTO))
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        block(.failure(Self.error(from: response as? HTTPURLResponse)))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    block(.failure(Self.error(from: response as? HTTPURLResponse)))
                }
            }
        }
        self.dataTask?.resume()
    }
}
