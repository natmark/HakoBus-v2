//
//  GetBusStopsRequest.swift
//  HakoBus-v2
//
//  Created by AtsuyaSato on 2018/03/30.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import APIKit

struct GetBusStopsRequest: BusRequest {
    typealias Response = [BusStop]

    let searchText: String

    var queryParameters: [String: Any]? {
        return [
            "search_text": searchText,
        ]
    }

    init(searchText: String) {
        self.searchText = searchText
    }

    var path: String {
        return "AKfycbw1TI6OFxgd6iST4L-34oNfG-aSb8KgJZMR06w_Xfmgn4Q8SLVH/exec"
    }

    var method: HTTPMethod {
        return .get
    }
}
