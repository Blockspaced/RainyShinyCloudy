//
//  Forecast.swift
//  RainyShinyCloudy
//
//  Created by smbss on 22/09/2016.
//  Copyright © 2016 smbss. All rights reserved.
//

import UIKit
import Alamofire

class Forecast {
    
    var _date: String!
    var _weatherType: String!
    var _highTemp: String!
    var _lowTemp: String!
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var highTemp: String {
        if _highTemp == nil {
            _highTemp = ""
        }
        return _highTemp
    }
    
    var lowTemp: String {
        if _lowTemp == nil {
            _lowTemp = ""
        }
        return _lowTemp
    }
    
    init(weatherDict: Dictionary<String,AnyObject>) {
            // Inside each day we have the "temp" dictionary that has the min and max temps
        if let temp = weatherDict["temp"] as? Dictionary<String,AnyObject> {
            
            if let min = temp["min"] as? Double {
                let kelvinToCelsius = round(min - 273.15)
                self._lowTemp = "\(kelvinToCelsius)"
            }
            
            if let max = temp["max"] as? Double {
                let kelvinToCelsius = round(max - 273.15)
                self._highTemp = "\(kelvinToCelsius)"
            }
            
        }
            // Inside each day we have the "weather" dictionary that has the weather type
        if let weather = weatherDict["weather"] as? [Dictionary<String,AnyObject>] {
            if let main = weather[0]["main"] as? String {
                self._weatherType = main
            }
        }
        
        if let date = weatherDict["dt"] as? Double {
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            self._date = unixConvertedDate.dayOfTheWeek()
        }
    }
    
}

    // Creating an extension from Date to easily extract the day of the week
extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // Code to get the full name of the weekday
        return dateFormatter.string(from: self)
    }
}
