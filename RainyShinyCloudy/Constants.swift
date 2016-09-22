//
//  Constants.swift
//  RainyShinyCloudy
//
//  Created by smbss on 20/09/2016.
//  Copyright © 2016 smbss. All rights reserved.
//

import Foundation

let API_CALL_TYPE = "Coordinates"

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"

let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "079f6a4d86fee21dabf0caf2af9357bf"
let CITY_STRING = "q="
var CURRENT_WEATHER_URL: String {
    var currentWeatherURL = ""
    if API_CALL_TYPE == "Coordinates" {
        currentWeatherURL = "\(BASE_URL)\(LATITUDE)-36\(LONGITUDE)123\(APP_ID)\(API_KEY)"
    } else if API_CALL_TYPE == "CityName" {
        currentWeatherURL = "\(BASE_URL)\(CITY_STRING)London,uk\(APP_ID)\(API_KEY)"
    }
    return currentWeatherURL
}

typealias DownloadComplete = () -> ()
