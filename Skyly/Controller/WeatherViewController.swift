//
//  ViewController.swift
//  Skyly
//
//  Created by Rosie Arasa on 1/8/22.
//    Copyright © 2022 Rosie Arasa. All rights reserved.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //as user for
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
       
        weatherManager.delegate = self
        searchTextField.delegate = self
       
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    

}
//MARK: - UITextFieldDelegate


extension WeatherViewController: UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if  let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "Type Something"
            return false
        }
    }
    
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
        
        
        print(weather.temperature)
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if  let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
        print("got location data")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print(error)
    }
}
