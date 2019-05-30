//
//  MeteoTests.swift
//  MeteoTests
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import XCTest

class MeteoTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecodeInfoClimatJsonFile() {
        let bundle = Bundle(for: type(of: self))

        guard let url = bundle.url(forResource: "infoClimat", withExtension: "json") else {
            XCTFail("Missing file")
            return
        }

        guard let jsonData = try? Data(contentsOf: url) else {
            XCTFail("Couldn't get data from url")
            return
        }

        let decoder = JSONDecoder()

        do {
            let userDto = try decoder.decode(MeteoDTO.self, from: jsonData)
            XCTAssertNotNil(userDto)
        } catch {
            XCTFail("Couldn't get decode data")
        }
    }

}
