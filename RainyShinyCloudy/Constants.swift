//
//  Constants.swift
//  RainyShinyCloudy
//
//  Created by smbss on 20/09/2016.
//  Copyright © 2016 smbss. All rights reserved.
//

import Foundation

let BASE_URL = "https://api.darksky.net/forecast/"
let API_KEY = "22e8b3dab1ac62c6f95fa9a1c4a015d3"
var CURRENT_WEATHER_URL = "\(BASE_URL)\(API_KEY)/\(Location.sharedInstance.latitude!),\(Location.sharedInstance.longitude!)"

typealias DownloadComplete = () -> ()
