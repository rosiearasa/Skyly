//
//  WeatherManager.swift
//  Skyly
//
//  Created by Rosie Arasa on 1/7/22.
//   Copyright © 2022 Rosie Arasa. All rights reserved.
//

import Foundation
import CoreLocation
protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=APIID&units=metric"
    
    var delegate : WeatherManagerDelegate?
    func fetchWeather(cityName: String){
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(with: urlString)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        // create a url
        if let url = URL(string: urlString){
            //create a URL Session
            let session = URLSession(configuration: .default)
            
            
            
            //GIVE the session a TASK
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    print(error!)
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{

                    if let weather =   self.parseJSON(safeData){
                        // send it back to the weather view controller
                        self.delegate?.didUpdateWeather(self, weather:weather)
                    }
                }
            }
            
            //start a task
            task.resume()
            
        }
    }
        func parseJSON(_ weatherData: Data) -> WeatherModel? {
            let decoder = JSONDecoder()
            do{
               let decodedData =  try decoder.decode(WeatherData.self, from: weatherData)
                print(decodedData.name)
                let id = decodedData.weather[0].id
                
                let temp = decodedData.main.temp
                let name = decodedData.name
                
                let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
                return weather
                }catch{
                    print(error)
                    delegate?.didFailWithError(error: error)
                    return nil
                }
             
            }
   
    
    
}
