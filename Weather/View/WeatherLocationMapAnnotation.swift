//
//  WeatherLocationMapAnnotation.swift
//  Weather
//
//  Created by Anton Larchenko on 10.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import Foundation
import MapKit

final class WeatherLocationMapAnnotation: NSObject, MKAnnotation {
  let title: String?
  let subtitle: String?
  let isDayTime: Bool?
  let coordinate: CLLocationCoordinate2D
  let locationId: Int
  
  init(
    title: String?,
    subtitle: String?,
    isDayTime: Bool?,
    coordinate: CLLocationCoordinate2D,
    locationId: Int
  ) {
    self.title = title
    self.subtitle = subtitle
    self.isDayTime = isDayTime
    self.coordinate = coordinate
    self.locationId = locationId
  }
  
  convenience init?(weatherDTO: WeatherInformationDTO?) {
    guard let weatherDTO = weatherDTO,
        let latitude = weatherDTO.coordinates?.latitude,
        let longitude = weatherDTO.coordinates?.longitude else {
        return nil
    }
    
    let isDayTime = ConversionWorker.isDayTime(for: weatherDTO.dayInformation, coordinates: weatherDTO.coordinates) ?? true
    
    var weatherConditionSymbol: String?
    if let weatherConditionIdentifier = weatherDTO.weatherCondition?.first?.identifier {
      weatherConditionSymbol = ConversionWorker.weatherConditionSymbol(
        fromWeatherCode: weatherConditionIdentifier,
        isDayTime: isDayTime
      )
    }
    
    let subtitle: String? = ""
      .append(contentsOf: weatherConditionSymbol, delimiter: .space)
      .ifEmpty(justReturn: nil)
    
    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    
    self.init(
      title: weatherDTO.cityName,
      subtitle: subtitle,
      isDayTime: isDayTime,
      coordinate: coordinate,
      locationId: weatherDTO.cityID ?? 0
    )
  }
}
