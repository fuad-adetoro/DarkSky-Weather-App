//
//  JSONDownloader.swift
//  DarkSky Weather App
//
//  Created by Fuad Adetoro on 10/06/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import Foundation

typealias JSON = [String: AnyObject]
typealias completionHandler = (JSON?, DarkSkyError?) -> Void

class JSONDownloader {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: URLSessionConfiguration.default)
    }
    
    func jsonTaskWith(request: URLRequest, completionHandler completion: @escaping completionHandler) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let httpURLReponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            if httpURLReponse.statusCode != 200 {
                completion(nil, .responseUnsuccessful)
                return
            }
            
            guard let data = data else {
                completion(nil, .invalidData)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON
                completion(json, nil)
            } catch {
                completion(nil, .jsonConversionFailure)
            }
        }
        
        return task
    }
}

