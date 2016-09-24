//
//  WeatherVC.swift
//  RainyShinyCloudy
//
//  Created by smbss on 14/09/16.
//  Copyright © 2016 smbss. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var locationManager: CLLocationManager!
    
    var currentWeather: CurrentWeather!
    var forecast: Forecast!
    var forecasts = [Forecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
            // Setting the location delegate to the current class
        locationManager.delegate = self
            // Setting the user authorization for when the app is in use
        locationManager.requestWhenInUseAuthorization()
            // Setting the accuracy to be the best
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestLocation()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        currentWeather = CurrentWeather()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("!LOCATION FIRST: \(locations.first)")
        print("!LOCATIONS: \(locations)")
        if let currentLocation = locations.first {
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            currentWeather.downloadWeatherDetails {
                    //Setup the UI to load the data
                self.downloadForecastData {
                    self.updateMainUI()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("!PERMISSION GRANTED: \(status)")
        } else {
            print("!PERMISSION STATUS: \(status)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete) {
            // Downloading the forecast data for the Tableview
        let forecastURL = URL(string: CURRENT_WEATHER_URL)
        Alamofire.request(forecastURL!, method: .get).responseJSON { response in
            let result = response.result
            
                // Fetching the forecast dict in the correct format
            if let dict = result.value as? Dictionary<String,AnyObject> {
                
                    // Fetching the list of all the forecast dictionaries
                if let list = dict["list"] as? [Dictionary<String,AnyObject>] {
                    
                        // Looping through each day and fetching the day dictionary
                    for obj in list {
                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                        print(obj)
                    }
                        // Remove the current day from the forecast array
                    self.forecasts.remove(at: 0)
                        // Reloading the table data
                    self.tableView.reloadData()
                }
            }
            completed()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell {
            
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
        } else {
            return WeatherCell()
        }
    }

    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)°C"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }
}

