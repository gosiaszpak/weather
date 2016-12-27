//
//  LocationDatastore.swift
//  PrettyWeather
//
//  Created by Gosia Szpak on 25.10.2016.
//  Copyright © 2016 Gosia Szpak. All rights reserved.
//

import CoreLocation

struct  Location {
    let lat: Double
    let lon: Double
}


class LocationDatastore: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    typealias LocationClosure = (Location) -> Void
    private let onLocationFound: LocationClosure
    
    typealias LocationErrorDisplClosure = (String?) -> Void
    private let onLocationError: LocationErrorDisplClosure
    
    
    init(errorClosure: @escaping LocationErrorDisplClosure, closure: @escaping LocationClosure){
        onLocationFound = closure
        onLocationError = errorClosure
        
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        startUpdating()
        
    }
    
    private func startUpdating(){
        locationManager.startUpdatingLocation()
    }
    
    private func stopUpdating(){
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
                NSLog("Error : \(error)")
                self.onLocationError("\(error)")
        
        
        DispatchQueue.main.async {
            self.onLocationFound(Location(lat: 37.3175, lon: 122.0419))
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        
        
        let coord = locationObj.coordinate
        
        DispatchQueue.main.async {
            self.onLocationFound(Location(lat: coord.latitude, lon: coord.longitude))
        }
        
        stopUpdating()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var message = ""
        switch status {
        case .restricted:
            message = "Denied access: Restricted access to location"
            NSLog(message)
            //self.onLocationError(message)
        case .denied:
            message = "Denied access: User denied access to location"
            NSLog(message)
            //self.onLocationError(message)
        case .notDetermined:
            message = "Denied access: Status not determined"
            NSLog(message)
            //self.onLocationError(message)
        default:
            NSLog("Allowed to location access")
            startUpdating()
        }
    }
    
}
    
