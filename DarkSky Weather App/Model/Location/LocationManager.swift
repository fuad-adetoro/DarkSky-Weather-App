//
//  LocationManager.swift
//  DarkSky Weather App
//
//  Created by Fuad Adetoro on 15/06/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import Foundation

typealias LocationManagerReference = (name: String, coordinate: Coordinate)

class LocationManager {
    func createLocations() -> [Location] {
        let currentLocations = getCurrentLocations()
        
        var locations: [Location] = []
        
        for currentLocation in currentLocations {
            let location = Location(name: currentLocation.name, coordinate: currentLocation.coordinate)
            
            locations.append(location)
        }
        
        return locations
    }
    
    
    func getCurrentLocations() -> [LocationManagerReference] {
        let londonLocation: LocationManagerReference = (name: "London", coordinate: Coordinate(latitude: 51.5239227, longitude: -0.0844997))
        
        let parisLocation: LocationManagerReference = (name: "Paris", coordinate: Coordinate(latitude: 48.858612, longitude: 2.342251))
        
        let newYorkLocation: LocationManagerReference = (name: "New York", coordinate: Coordinate(latitude: 40.783512, longitude: -73.820419))
        
        let losAngelesLocation: LocationManagerReference = (name: "Los Angeles", coordinate: Coordinate(latitude: 34.036095, longitude: -118.248354))
        
        let tokyoLocation: LocationManagerReference = (name: "Tokyo", coordinate: Coordinate(latitude: 35.679955, longitude: 139.843587))
        
        let currentLocations: [LocationManagerReference] = [londonLocation, parisLocation, newYorkLocation, losAngelesLocation, tokyoLocation]
        
        return currentLocations
    }
}
