//
//  WeatherStationDTO.swift
//  Weather
//
//  Created by Anton Larchenko on 10.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import Foundation

struct WeatherStationDTO : Codable {
    let message : String?
    let cod : String?
    let count : Int?
    let list : [WeatherInformationDTO]?

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case cod = "cod"
        case count = "count"
        case list = "list"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        cod = try values.decodeIfPresent(String.self, forKey: .cod)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        list = try values.decodeIfPresent([WeatherInformationDTO].self, forKey: .list)
    }
    
    static func make(data: Data) -> WeatherStationDTO? {
        return try? JSONDecoder().decode(WeatherStationDTO.self, from: data)
    }

}
