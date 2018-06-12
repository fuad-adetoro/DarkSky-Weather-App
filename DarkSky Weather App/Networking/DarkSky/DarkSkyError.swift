//
//  DarkSkyError.swift
//  DarkSky Weather App
//
//  Created by Fuad Adetoro on 10/06/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import Foundation

enum DarkSkyError: Error {
    case requestFailed
    case responseUnsuccessful
    case invalidData
    case invalidURL
    case jsonConversionFailure
    case jsonParsingFailure
}
