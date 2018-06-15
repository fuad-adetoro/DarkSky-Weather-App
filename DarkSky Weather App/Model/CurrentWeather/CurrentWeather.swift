//
//  CurrentWeather.swift
//  DarkSky Weather App
//
//  Created by Fuad Adetoro on 11/06/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import Foundation

enum WeatherKeys: String {
    case temperature = "temperature"
    case humidity = "humidity"
    case precipProbability = "precipProbability"
    case summary = "summary"
}

struct CurrentWeather {
    let temperature: Double
    let humidity: Double
    let precipProbability: Double
    let summary: String
    
    init?(json: [String: AnyObject]) {
        guard let tempValue = json[WeatherKeys.temperature.rawValue] as? Double, let humidityValue = json[WeatherKeys.humidity.rawValue] as? Double, let precipProbabilityValue = json[WeatherKeys.precipProbability.rawValue] as? Double, let summaryValue = json[WeatherKeys.summary.rawValue] as? String else {
            return nil
        }
        
        self.temperature = tempValue
        self.humidity = humidityValue
        self.precipProbability = precipProbabilityValue
        self.summary = summaryValue
    }
}

