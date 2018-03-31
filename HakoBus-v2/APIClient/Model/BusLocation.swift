//
//  BusLocation.swift
//  HakoBus-v2
//
//  Created by AtsuyaSato on 2018/03/30.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//
// swiftlint:disable nesting

struct BusLocation: Codable {
    let route: String
    let destination: String
    let departureTime: String
    let destinationTime: String
    let estimatedDepartureTime: String
    let estimatedDestinationTime: String
    let requiredTime: String
    let transfer: String
    let departureInfo: String
    let betStop: BetStop

    struct BetStop: Codable {
        let fromSignpoleKey: Int
        let toSignpoleKey: Int
        let routePatternCd: Int
        let sourceTime: Int
        enum CodingKeys: String, CodingKey {
            case fromSignpoleKey = "from_signpole_key"
            case toSignpoleKey = "to_signpole_key"
            case routePatternCd = "route_pattern_cd"
            case sourceTime = "source_time"
        }
    }

    enum CodingKeys: String, CodingKey {
        case route
        case destination
        case departureTime = "departure_time"
        case destinationTime = "destination_time"
        case estimatedDepartureTime = "estimated_departure_time"
        case estimatedDestinationTime = "estimated_destination_time"
        case requiredTime = "required_time"
        case transfer
        case departureInfo = "departure_info"
        case betStop = "bet_stop"
    }
}
