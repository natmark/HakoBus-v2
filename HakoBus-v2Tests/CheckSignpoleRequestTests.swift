//
//  CheckSignpoleRequestTests.swift
//  HakoBus-v2Tests
//
//  Created by AtsuyaSato on 2018/03/30.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Foundation
import XCTest
import APIKit
import OHHTTPStubs
@testable import HakoBus_v2

extension Collection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class CheckSignpoleRequestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        HttpHelper.stubRequest(from: "", to: "", file: "CheckSignpole.json")

        let stubSet: [(departure: String, destination: String)] = [
            ("亀田支所前", "亀田支所前"),
            ("亀田支所前", "はこだて未来大学"),
            ("亀田支所前", "未来大"),
            ("空港", "はこだて未来大学"),
        ]

        for stub in stubSet {
            HttpHelper.stubRequest(from: stub.departure, to: stub.destination, file: "CheckSignpole-\(stub.departure)-\(stub.destination).json")
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func testCheckSignpole() {
        let checkSignpoleRequestExpectation: XCTestExpectation? = self.expectation(description: "check signpole")
        let request = CheckSignpoleRequest(from: "空港", to: "はこだて未来大学")

        Session.send(request) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.successStatus, false)
                XCTAssertEqual(response.errors[safe: 0]?.errorMessage, "出発 指定した停留所は見つかりませんでした。")
                checkSignpoleRequestExpectation?.fulfill()
            case .failure(_): break
            }
        }

        waitForExpectations(timeout: 0.2, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
