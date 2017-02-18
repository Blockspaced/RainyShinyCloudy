//
//  Constants.swift
//  RainyShinyCloudy
//
//  Created by smbss on 20/09/2016.
//  Copyright © 2016 smbss. All rights reserved.
//

import Foundation

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let BASE_URL_FORECAST = "http://api.openweathermap.org/data/2.5/forecast/daily?"

let LATITUDE = "lat=\(Location.sharedInstance.latitude!)"
let LONGITUDE = "&lon=\(Location.sharedInstance.longitude!)"

let API_KEY = "&appid=079f6a4d86fee21dabf0caf2af9357bf"
var CURRENT_WEATHER_URL = "\(BASE_URL)\(LATITUDE)\(LONGITUDE)\(API_KEY)"
var CURRENT_FORECAST_URL = "\(BASE_URL_FORECAST)\(LATITUDE)\(LONGITUDE)&cnt=10&mode=json\(API_KEY)"

typealias DownloadComplete = () -> ()
