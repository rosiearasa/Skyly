//
//  WeatherData.swift
// Skyly
//
//  Created by Rosie Arasa on 1/8/22.
//Copyright © 2022 Rosie Arasa. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let  weather:[Weather]
    
}
struct Main: Codable{
    let temp: Double
}
struct Weather:Codable{
    
    let id: Int
}
