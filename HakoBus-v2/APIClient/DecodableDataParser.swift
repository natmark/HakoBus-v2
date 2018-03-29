//
//  DecodableDataParser.swift
//  HakoBus-v2
//
//  Created by AtsuyaSato on 2018/03/30.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Foundation
import APIKit

class DecodableDataParser: APIKit.DataParser {
    var contentType: String? {
        return "application/json"
    }

    func parse(data: Data) throws -> Any {
        return data
    }
}
