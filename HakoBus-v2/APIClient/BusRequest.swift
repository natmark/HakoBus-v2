//
//  BusRequest.swift
//  HakoBus-v2
//
//  Created by AtsuyaSato on 2018/03/30.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Foundation
import APIKit

protocol BusRequest: Request {

}

extension BusRequest where Self == CheckSignpoleRequest {
    var baseURL: URL {
        return URL(string: "https://hakobus.bus-navigation.jp/wgsys/wgs/")!
    }
}

extension BusRequest where Self == GetBusStopsRequest {
    var baseURL: URL {
        return URL(string: "https://script.google.com/macros/s/")!
    }
}

extension BusRequest where Self == GetBusApproachRequest {
    var baseURL: URL {
        return URL(string: "https://script.google.com/macros/s/")!
    }
}

extension BusRequest {
    var dataParser: DataParser {
        return DecodableDataParser()
    }
}

extension BusRequest {
    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        return urlRequest
    }

    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard (200..<300).contains(urlResponse.statusCode) else {
            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
        }
        return object
    }
}

extension BusRequest where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }

        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}
