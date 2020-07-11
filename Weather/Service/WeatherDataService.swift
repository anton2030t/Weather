//
//  WeatherService.swift
//  Weather
//
//  Created by Anton Larchenko on 10.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import Foundation
import CoreLocation

enum Result<T> {
    case success(T)
    case failure(Error)
}

final class WeatherDataService {
    
    private let apiKey = "c6e381d8c7ff98f0fee43775817cf6ad"
    private let networking: Networking
    
    private(set) var bookmarkedWeatherDataObjects: [WeatherInformationDTO]?
    private(set) var nearbyWeatherDataObject: WeatherInformationDTO?
    
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    
    /// Fetch bookmarks data
    /// - Parameter completion: Called when operation finishes
    func fetchBookmarkedLocations(_ location: String, completion: @escaping (Result<WeatherInformationDTO?>) -> Void) {
        let resource = Resource(url: Constants.Urls.kOpenWeatherBaseUrl, path: "data/2.5/weather", parameters:
            ["q": location,
             "appid": apiKey
        ])
        
        _ = networking.fetch(resource: resource, completion: { data in
            DispatchQueue.main.async {
                completion(.success(data.flatMap({ WeatherInformationDTO.make(data: $0) }) ))
            }
        })
    }
    
    /// Fetch forecast data
    /// - Parameter completion: Called when operation finishes
    func fetchFiveDayForecast(_ location: String, completion: @escaping (Result<[WeatherInformationDTO]?>) -> Void) {
        let resource = Resource(url: Constants.Urls.kOpenWeatherBaseUrl, path: "data/2.5/forecast", parameters:
            ["q": location,
             "appid": apiKey
        ])
        
        _ = networking.fetch(resource: resource, completion: { data in
            DispatchQueue.main.async {
                completion(.success(data.flatMap({ WeatherForecastDTO.make(data: $0) })?.list ?? [] ))
            }
        })
    }
    
    /// Fetch multiple station data
    /// - Parameter completion: Called when operation finishes
    func fetchNearbyLocations(_ coordinate: CLLocationCoordinate2D, completion: @escaping (Result<[WeatherInformationDTO]?>) -> Void) {
        let resource = Resource(url: Constants.Urls.kOpenWeatherBaseUrl, path: "data/2.5/find", parameters:
            ["appid": apiKey,
             "lat": "\(coordinate.latitude)",
                "lon": "\(coordinate.longitude)"
        ])
        
        _ = networking.fetch(resource: resource, completion: { data in
            DispatchQueue.main.async {
                completion(.success(data.flatMap({ WeatherStationDTO.make(data: $0) })?.list ?? [] ))
            }
        })
    }
}




