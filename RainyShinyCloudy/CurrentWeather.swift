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
        self._date = "Today, \(currentDate)"
        
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
    func downloadWeatherDetails(completed: DownloadComplete) {
        // In Constants.swift a typealias for DownloadComplete was created
        // This will allow us to know when this function is completed
    
        let currentWeatherURL = URL(string: CURRENT_WEATHER_URL)!
            // Creating the Alamofire request
        Alamofire.request(currentWeatherURL, method:.get).responseJSON{ response in
            // We erased the completion block and added "response in" so that we can specify how we want to receive the response
            
                // Every request has a response and every response has a result
            let result = response.result
            print(response)
        }
        completed()
    }
}
