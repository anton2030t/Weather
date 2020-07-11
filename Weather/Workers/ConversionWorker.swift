//
//  ConversionWorker.swift
//  Weather
//
//  Created by Anton Larchenko on 10.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import Foundation
import MapKit

final class ConversionWorker {
  
  static func weatherConditionSymbol(fromWeatherCode code: Int?, isDayTime: Bool) -> String {
    guard let code = code else {
      return "❓"
    }
    switch code {
    case let x where (x >= 200 && x <= 202) || (x >= 230 && x <= 232):
      return "⛈"
    case let x where x >= 210 && x <= 211:
      return "🌩"
    case let x where x >= 212 && x <= 221:
      return "⚡️"
    case let x where x >= 300 && x <= 321:
      return "🌦"
    case let x where x >= 500 && x <= 531:
      return "🌧"
    case let x where x >= 600 && x <= 602:
      return "☃️"
    case let x where x >= 603 && x <= 622:
      return "🌨"
    case let x where x >= 701 && x <= 771:
      return "🌫"
    case let x where x == 781 || x == 900:
      return "🌪"
    case let x where x == 800:
      return isDayTime ? "☀️" : "🌕"
    case let x where x == 801:
      return "🌤"
    case let x where x == 802:
      return "⛅️"
    case let x where x == 803:
      return "🌥"
    case let x where x == 804:
      return "☁️"
    case let x where x >= 952 && x <= 956 || x == 905:
      return "🌬"
    case let x where x >= 957 && x <= 961 || x == 771:
      return "💨"
    case let x where x == 901 || x == 902 || x == 962:
      return "🌀"
    case let x where x == 903:
      return "❄️"
    case let x where x == 904:
      return "🌡"
    case let x where x == 962:
      return "🌋"
    default:
      return "❓"
    }
  }
    
    static  func convertToCelsius(_ kelvinTemp: Double) -> String {
        let celsiusTemp = kelvinTemp - 273.15
        return String(format: "%.0f", celsiusTemp)
    }
    
    static func isDayTime(for dayTimeInformation: DayInformation?, coordinates: Coordinates?) -> Bool? {
      
      guard let sunrise =  dayTimeInformation?.sunrise,
        let sunset =  dayTimeInformation?.sunset else {
          return nil
      }
      
      let calendar = Calendar.current
      
      let currentTimeDateComponents = calendar.dateComponents([.hour, .minute], from: Date())
      let sunriseDate = Date(timeIntervalSince1970: sunrise)
      let sunriseDateComponents = calendar.dateComponents([.hour, .minute], from: sunriseDate)
      let sunsetDate = Date(timeIntervalSince1970: sunset)
      let sunsetDateComponents = calendar.dateComponents([.hour, .minute], from: sunsetDate)
      
      guard let currentTimeDateComponentHour = currentTimeDateComponents.hour,
        let currentTimeDateComponentMinute = currentTimeDateComponents.minute,
        let sunriseDateComponentHour = sunriseDateComponents.hour,
        let sunriseDateComponentMinute = sunriseDateComponents.minute,
        let sunsetDateComponentHour = sunsetDateComponents.hour,
        let sunsetDateComponentMinute = sunsetDateComponents.minute else {
          return nil
      }
      
      return ((currentTimeDateComponentHour == sunriseDateComponentHour
        && currentTimeDateComponentMinute >= sunriseDateComponentMinute)
        || currentTimeDateComponentHour > sunriseDateComponentHour)
        && ((currentTimeDateComponentHour == sunsetDateComponentHour
          && currentTimeDateComponentMinute <= sunsetDateComponentMinute)
          || currentTimeDateComponentHour < sunsetDateComponentHour)
    }
}

