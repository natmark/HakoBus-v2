//
//  CheckSignpoleResponse.swift
//  HakoBus-v2
//
//  Created by AtsuyaSato on 2018/03/30.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

struct CheckSignpoleResponse: Codable {
    let successStatus: Bool
    let errors: [CheckSignpoleError]

    struct CheckSignpoleError: Codable, Error {
        let errorCd: String?
        let errorMessage: String
        let errorType: String?
        let rowNumber: String?
    }
}
