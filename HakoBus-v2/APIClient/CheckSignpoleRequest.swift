//
//  CheckSignpoleRequest.swift
//  HakoBus-v2
//
//  Created by AtsuyaSato on 2018/03/30.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import APIKit

struct CheckSignpoleRequest: BusRequest {
    typealias Response = CheckSignpoleResponse

    enum SignpoleType: Int {
        case busStop = 1
        case landmark = 2
        case currentLocation = 3
    }

    let locale = "ja"
    let from: String
    var fromType: SignpoleType = .busStop
    var to: String
    var toType: SignpoleType = .busStop

    var queryParameters: [String: Any]? {
        return [
            "locale": locale,
            "from": from,
            "fromType": fromType.rawValue,
            "to": to,
            "toType": toType.rawValue
        ]
    }

    init(from: String, to: String) {
        self.from = from
        self.to = to
    }

    var path: String {
        return "/checkSignpole.htm"
    }

    var method: HTTPMethod {
        return .post
    }

}
