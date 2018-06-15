//
//  WeatherManager.swift
//  DarkSky Weather App
//
//  Created by Fuad Adetoro on 15/06/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import Foundation

typealias WeatherManagerCompletion = ([CurrentWeatherViewModel], Error?) -> Void

class WeatherManager {
    func fetchWeather(with locations: [Location], completion: @escaping WeatherManagerCompletion) {
        let darkSkyAPIClient = DarkSkyAPIClient()
        
        let dispatchGroup = DispatchGroup()
        
        var error: Error?
        
        var currentWeatherViewModels: [CurrentWeatherViewModel] = []
        
        for location in locations {
            dispatchGroup.enter()
            
            darkSkyAPIClient.getCurrentWeather(at: location.coordinate, completionHandler: { (currentWeather, darkSkyError) in
                if let currentWeather = currentWeather {
                    let currentWeatherViewModel = CurrentWeatherViewModel(from: currentWeather, location: location)
                    currentWeatherViewModels.append(currentWeatherViewModel)
                } else {
                    error = darkSkyError
                }
                
                dispatchGroup.leave()
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(currentWeatherViewModels, error)
        }
    }
}
