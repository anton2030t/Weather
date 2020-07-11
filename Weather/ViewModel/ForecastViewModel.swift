//
//  ForecastViewModel.swift
//  Weather
//
//  Created by Anton Larchenko on 10.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

struct ForecastViewModel {
    var weekday: String?
    var temperature: String?
    var weatherCondition: String?
    var icon: UIImage?
    
    init(model: WeatherInformationDTO) {
        self.weekday = ForecastViewModel.getDayOfWeek(from: model.date ?? 0.0)
        self.weatherCondition = model.weatherCondition?[0].conditionName
        self.temperature = "\(ConversionWorker.convertToCelsius(model.atmosphericInformation?.temperatureKelvin ?? 0.0)) \(Constants.Values.TemperatureUnit.kCelsius)"
        let weatherIcon = WeatherIcon(iconString: (model.weatherCondition?[0].icon ?? ""))
        self.icon = weatherIcon.image
    }
    
    static func getDayOfWeek(from fromDate: Double) -> String {
        let date = Date(timeIntervalSince1970: fromDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeekString = dateFormatter.string(from: date)
        
        return dayOfWeekString
    }
}
