//
//  DarkSkyAPIClient.swift
//  DarkSky Weather App
//
//  Created by Fuad Adetoro on 10/06/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import Foundation

typealias CurrentWeatherCompletionHandler = (CurrentWeather?, DarkSkyError?) -> Void

class DarkSkyAPIClient {
    lazy var baseURL: URL = {
        return URL(string: "https://api.darksky.net/forecast/\(DarkSkyAPI.apiKey)/")!
    }()
    
    let downloader = JSONDownloader()
    
    func getCurrentWeather(at coordinate: Coordinate, completionHandler completion: @escaping CurrentWeatherCompletionHandler) {
        guard let url = URL(string: coordinate.description, relativeTo: baseURL) else {
            completion(nil, .invalidURL)
            return
        }
        
        let request = URLRequest(url: url)
        let task = downloader.jsonTaskWith(request: request) { (json, error) in
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, error)
                    return
                }
                
                guard let jsonDictionary = json["currently"] as? [String: AnyObject], let currentWeather = CurrentWeather(json: jsonDictionary) else {
                    completion(nil, .jsonParsingFailure)
                    return
                }
                
                completion(currentWeather, nil)
            }
        }
        
        task.resume()
    }
}
