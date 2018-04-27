//
//  BackGroundViewController.swift
//  Twicether
//
//  Created by Lam Ngo on 12/28/17.
//  Copyright © 2017 Lam Ngo. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class BackGroundViewController: UIViewController, CLLocationManagerDelegate {
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "700de758eda61aa38e19d0cf6b8493b6"
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temp: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let random : UInt32 = arc4random_uniform(3) + 1
        let someInt : Int = Int(random)
        image.image = UIImage(named: String(someInt))
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWeatherData(url : String, parameters: [String:String]){
        Alamofire.request(url , method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                let weatherJSON : JSON = JSON(response.result.value!)
                
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                self.cityLabel.text = "Connection issues"
            }
        }
    }
    
    func updateWeatherData(json : JSON){
        
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()
        } else{
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temp.text = "\(weatherDataModel.temperature)"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count-1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            print ("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String (location.coordinate.latitude)
            let longitude = String (location.coordinate.longitude)
            let params : [String : String] = ["lat":latitude,"lon":longitude,"appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }

}
