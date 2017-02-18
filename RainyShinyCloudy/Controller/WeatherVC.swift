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

    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var locationManager: CLLocationManager!
    
    var currentWeather: CurrentWeather!
    var forecasts = [Forecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        warningLabel.isHidden = true
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
            // Setting location accuracy to minimum - save battery and time
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers

        tableView.delegate = self
        tableView.dataSource = self
        
        currentWeather = CurrentWeather()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            // Runs when locations are found after .requestLocation()
        
        manager.stopUpdatingLocation()
        warningLabel.isHidden = true

        if (Location.sharedInstance.latitude == nil ) || (Location.sharedInstance.longitude == nil) {
                // This validation prevents Forecasts array to be populated multiple times
            
            if let currentLocation = locations.first {
                Location.sharedInstance.latitude = currentLocation.coordinate.latitude
                Location.sharedInstance.longitude = currentLocation.coordinate.longitude
                currentWeather.downloadWeatherDetails {
                        // Runs when .downloadWeatherDetails is completed
                    self.downloadForecastData {
                            // Runs when .downloadForecastData is completed
                        self.updateMainUI()
                    }
                }
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            // Runs when CLLocationManager is instanciated (viewDidLoad)
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            manager.requestLocation()
            break
        default:
                // Other cases: .denied .restricted and .authorizedAlways
                // Not relevant to deal with .authorizedAlways because we won't ask it in this app
            showWarning(text: "Please authorize access to your location in order to use the app")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showWarning(text: "Failed to find user's location:\n \(error.localizedDescription)")
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete) {
        let forecastURL = URL(string: CURRENT_FORECAST_URL)
        
        Alamofire.request(forecastURL!).responseJSON { response in
            switch response.result  {
            case .success:
                let result = response.result
                    // Casting the forecast dict in the correct format
                if let dict = result.value as? Dictionary<String,AnyObject> {
                        // Fetching the list with all the forecast dictionaries
                    if let list = dict["list"] as? [Dictionary<String,AnyObject>] {
                            // Looping through each day and fetching the weather dictionary
                        for obj in list {
                            let forecast = Forecast(weatherDict: obj)
                            self.forecasts.append(forecast)
                        }
                            // Removing the current day from the forecast array
                        self.forecasts.remove(at: 0)
                            // Reloading the table data
                        self.tableView.reloadData()
                    } else {
                        self.showWarning(text: "Failed to convert data from Weather API")
                    }
                } else {
                    self.showWarning(text: "Failed to convert data from Weather API")
                }
                break
            case .failure(let error):
                self.showWarning(text: "Can't connect to API: \(error) ")
                break
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
    
    func showWarning(text: String) {
        warningLabel.text = "\(text)"
        warningLabel.isHidden = false
    }
}

