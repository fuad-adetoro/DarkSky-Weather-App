//
//  Coordinate.swift
//  DarkSky Weather App
//
//  Created by Fuad Adetoro on 10/06/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import Foundation

struct Coordinate {
    let latitude: Double
    let longitude: Double
}

extension Coordinate: CustomStringConvertible {
    var description: String {
        return "\(latitude),\(longitude)"
    }
}
