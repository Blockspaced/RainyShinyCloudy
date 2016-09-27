//
//  CurrentWeather.swift
//  RainyShinyCloudy
//
//  Created by smbss on 20/09/2016.
//  Copyright © 2016 smbss. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeather {
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _currentTemp: Double!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        
        // Defining the date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
            // Removing the time because by default it is returned
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today\n \(currentDate)"
        
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
        // Creating the func that will download data
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        // In Constants.swift a typealias for DownloadComplete was created
        // This will allow us to know when this function is completed
        
        
        let currentWeatherURL = URL(string: CURRENT_WEATHER_URL)!
        print("!CURRENTURL: \(currentWeatherURL)")
            // Creating the Alamofire request
        Alamofire.request(currentWeatherURL, method:.get).responseJSON{ response in
            // We erased the completion block and added "response in" so that we can specify how we want to receive the response
            print("!RESPONSE: \(response)")
                // Every request has a response and every response has a result
            let result = response.result
            print("!RESULT: \(result)")
                // Creating a dictionary that will contain the value of the result
                // It will be casted in the same format as the dictionary from the API (String: AnyObject)
            if let dict = result.value as? Dictionary<String, AnyObject> {
                print("!DICT1:\(dict)")
                
                    // Fetching the city name and make the first letter capitalized
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                }
                
                print("!TIMEZONE: \(dict["timezone"])")
                
                    // Fetching the weather dictionary from inside the dict and casting it correctly (as an array of dictionaries)
                if let weather = dict["weather"] as? [Dictionary<String,AnyObject>] {
                    
                        // Weather is an array of dicts and we only want the first entry and "main" is the key for the weather type
                    if let main = weather[0]["main"] as? String {
                        self._weatherType = main.capitalized
                    }
                    
                }
                
                    // Accessing the other "main" dictionay that is one of the top parents and not inside the weather array
                if let main = dict["main"] as? Dictionary<String,AnyObject> {
                    
                    if let currentTemperature = main["temp"] as? Double {
                        
                        let kelvinToCelsius = round(currentTemperature - 273.15)
                        
//                        let kelvinToFarenheitPreDivision = (currentTemperature * (9/5) - 459.67)
//                        let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))

                        self._currentTemp = kelvinToCelsius
                    }
                }
                
            
            } else {
                print("!ERROR: Dict not created")
            }
            self.printData()
            completed()
        }
    }
    
    func printData() {
        print("!DATA: \(self._cityName)")
        print("!DATA: \(self._weatherType)")
        print("!DATA: \(self._currentTemp)")
    }
}
