//
//  GetBusApproachRequest.swift
//  HakoBus-v2
//
//  Created by AtsuyaSato on 2018/03/30.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import APIKit

struct GetBusApproachRequest: BusRequest {
    typealias Response = [BusLocation]

    let from: String
    let to: String

    var queryParameters: [String: Any]? {
        return [
            "from": from,
            "to": to
        ]
    }

    init(from: String, to: String) {
        self.from = from
        self.to = to
    }

    var path: String {
        return "AKfycbzBiiZZEr6p3rLlWiCyvSIOwkx9ed5z_C3xKul206VTMtI5DcBp/exec"
    }

    var method: HTTPMethod {
        return .get
    }
}
