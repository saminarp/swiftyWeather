//
//  WeatherMap.swift
//  Final WeatherApp
//
//  Created by Samina Rahman Purba on 2022-08-15.
//

import Foundation

struct WeatherMap : Codable {
    let name: String
    let main : Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let icon: String
}
