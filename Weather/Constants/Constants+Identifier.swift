//
//  Constants+Identifier.swift
//  Weather
//
//  Created by Anton Larchenko on 10.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import Foundation

extension Constants {
  enum Identifier {}
}

extension Constants.Identifier {
    enum ReuseIdentifier {
        static let kLocationResultCell = "LocationResultCell"
    }
    
    enum ViewController {
        static let kWeatherDetailViewController = "WeatherDetailViewController"
        static let kForecastViewController = "ForcastViewController"
    }
    
    enum Segue {
        static let kShowLocationSearch = "showLocationSearch"
    }
}
