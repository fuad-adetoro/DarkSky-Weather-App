//
//  CurrentWeatherModel.swift
//  DarkSky Weather App
//
//  Created by Fuad Adetoro on 10/06/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import UIKit
import Foundation

struct CurrentWeatherViewModel {
    let temperature: String
    let humidity: String
    let precipProbability: String
    let summary: String
    
    let location: Location
    
    init(from model: CurrentWeather, location: Location) {
        temperature = "\(model.temperature.int())º"
        
        let humidityValue = model.humidity.percent().int()
        humidity = "\(humidityValue)%"
        
        let precipValue = model.precipProbability.percent().int()
        precipProbability = "\(precipValue)%"
        
        summary = model.summary
        self.location = location
    }
}

extension Double {
    func percent() -> Double {
        return self * 100
    }
    
    func int() -> Int {
        return Int(self)
    }
}
