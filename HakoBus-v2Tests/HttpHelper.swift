//
//  HttpHelper.swift
//  HakoBus-v2Tests
//
//  Created by AtsuyaSato on 2018/03/30.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Foundation
import OHHTTPStubs

extension URL {
    public func queryParams() -> [String : String] {
        var params = [String : String]()

        guard let comps = URLComponents(string: self.absoluteString) else {
            return params
        }
        guard let queryItems = comps.queryItems else { return params }

        for queryItem in queryItems {
            params[queryItem.name] = queryItem.value
        }
        return params
    }
}

class HttpHelper {
    let host = "hakobus.bus-navigation.jp"

    static func stubRequest(from: String, to: String, file: String, status: Int32 = 200, headers: [String: String]? = nil) {
        OHHTTPStubs.stubRequests(
            passingTest: { (request) -> Bool in
                guard let url = request.url else {
                    return false
                }
                return url.queryParams()["from"] == from && url.queryParams()["to"] == to
        }, withStubResponse: { (request) -> OHHTTPStubsResponse in
            print("[TEST] Hit Stub")
            let stubPath = OHPathForFile(file, self)
            return OHHTTPStubsResponse(fileAtPath: stubPath!, statusCode: status, headers: headers)
        }
        )
    }
}
