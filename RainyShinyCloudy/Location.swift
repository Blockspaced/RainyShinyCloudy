//
//  Location.swift
//  RainyShinyCloudy
//
//  Created by smbss on 22/09/2016.
//  Copyright © 2016 smbss. All rights reserved.
//

import Foundation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double?
    var longitude: Double?
}
