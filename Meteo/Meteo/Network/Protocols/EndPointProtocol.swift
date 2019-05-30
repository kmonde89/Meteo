//
//  EndPointProtocol.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation

protocol EndPointProtocol {
    func getURL() -> URL?
    func getURLRequest() -> URLRequest?

    var endPoint: String {get}
    var method: Method {get }
}

enum Method: String {
    case post = "POST"
    case get = "GET"
}

extension EndPointProtocol {
    typealias  rawValue = String
    func getURL() -> URL? {
        return URL(string: #"http://www.infoclimat.fr/public-api/gfs/\#(self.endPoint)"#)
    }

    func getURLRequest() -> URLRequest? {
        guard let url = self.getURL() else {
            //throws error
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = self.method.rawValue
        return urlRequest
    }
}
