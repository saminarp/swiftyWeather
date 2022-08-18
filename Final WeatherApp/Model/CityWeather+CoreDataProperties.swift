//
//  CityWeather+CoreDataProperties.swift
//  Final WeatherApp
//
//  Created by Samina Rahman Purba on 2022-08-15.
//
//

import Foundation
import CoreData


extension CityWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityWeather> {
        return NSFetchRequest<CityWeather>(entityName: "CityWeather")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var cityTemp: Double
    @NSManaged public var weatherIcon: String?

}

extension CityWeather : Identifiable {

}
