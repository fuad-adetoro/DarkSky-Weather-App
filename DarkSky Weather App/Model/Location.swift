//
//  Location.swift
//  DarkSky Weather App
//
//  Created by Fuad Adetoro on 10/06/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import Foundation

struct Location {
    let name: String
    let coordinate: Coordinate
    
    init(name: String, coordinate: Coordinate) {
        self.name = name
        self.coordinate = coordinate
    }
}
