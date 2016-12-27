//
//  WeatherDatastore.swift
//  PrettyWeather
//
//  Created by Gosia Szpak on 26.10.2016.
//  Copyright © 2016 Gosia Szpak. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherDatastore {
    
    //let APIKey = "123"
    let APIKey = "f7fc57d2c46bec2dc246d9862ca06195"
    
    func retrieveCurrentWeatherAtLat(lat: CLLocationDegrees, lon: CLLocationDegrees, block: @escaping (_ weatherCondition: WeatherCondition ) -> Void , displError: @escaping (_ error: Error ) -> Void ){
        let url = "http://api.openweathermap.org/data/2.5/weather?appid=\(APIKey)"
        let params = ["lat": lat, "lon": lon]
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default , headers: nil).responseJSON { (response) in
            
        
            
            switch response.result {
            case .success(let json):
                let json = JSON(json)
                block(self.createWeatherConditionFromJson(json: json))
            case .failure(let error):
                print("dupa dupa dupa  \(error)")
                displError(error)
            }
            
        }
    }
    
    func retrieveHourlyForecastAtLat(lat: CLLocationDegrees, lon: CLLocationDegrees, block: @escaping (_ weatherConditions: Array<WeatherCondition>) -> Void , displError: @escaping (_ error: Error ) -> Void ){
        let url = "http://api.openweathermap.org/data/2.5/forecast?APPID=\(APIKey)"
        let params = ["lat":lat, "lon":lon]
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success(let json):
                let json = JSON(json)
                let list: Array<JSON> = json["list"].arrayValue
                
                let weatherConditions: Array<WeatherCondition> = list.map(){
                    return self.createWeatherConditionFromJson(json: $0)
                }
                
                block(weatherConditions)
                
            case .failure(let error):
                 print("dupa dupa dupa  \(error)")
                displError(error)
                
            }
            
        }
    }
    
    
    func retrieveDailyForecastAtLat(lat: Double, lon: Double, dayCnt: Int, block: @escaping (_ weatherConditions: Array<WeatherCondition>) -> Void , displError: @escaping (_ error: Error ) -> Void) {
        
        let url = "http://api.openweathermap.org/data/2.5/forecast/daily?APPID=\(APIKey)"
        let params = ["lat":lat, "lon":lon, "cnt":Double(dayCnt+1)]
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success(let json):
                    let json = JSON(json)
                    let list: Array<JSON> = json["list"].arrayValue
                    let weatherConditions: Array<WeatherCondition> = list.map(){
                            return self.createDayForecastFromJson(json: $0)
                    }
                    let count = weatherConditions.count
                    let daysWithoutToday = Array(weatherConditions[1..<count])
                    block(daysWithoutToday)
               case .failure(let error):
                 print("dupa dupa dupa  \(error)")
                displError(error)
            }
        }
        
        
    }
    
    func createWeatherConditionFromJson(json: JSON) -> WeatherCondition {
        let name = json["name"].stringValue
        let weather = json["weather"][0]["main"].stringValue
        let icon = json["weather"][0]["icon"].stringValue
        let dt = json["dt"].doubleValue
        let time = NSDate(timeIntervalSince1970: dt)
        let tempKelvin = json["main"]["temp"].doubleValue
        let maxTempKelvin = json["main"]["temp_max"].doubleValue
        let minTempKelvin = json["main"]["temp_min"].doubleValue
        
        let sunRise =  NSDate(timeIntervalSince1970: json["sys"]["sunrise"].doubleValue )
        let sunSet =  NSDate(timeIntervalSince1970: json["sys"]["sunset"].doubleValue )
        
        let humidity = json["main"]["humidity"].intValue
        let pressure = json["main"]["pressure"].intValue
        let visibility = json["visibility"].doubleValue
        
        return WeatherCondition(
            cityName: name,
            weather: weather,
            icon: IconType(rawValue: icon),
            time: time,
            tempKelvin: tempKelvin,
            maxTempKelvin: maxTempKelvin,
            minTempKelvin: minTempKelvin,
            sunRise: sunRise,
            sunSet: sunSet,
            humidity: humidity,
            pressure: pressure,
            visibility: visibility
        )
        
    }
    
    func createDayForecastFromJson(json: JSON) -> WeatherCondition {
        let name = ""
        let weather = json["weather"][0]["main"].stringValue
        let icon = json["weather"][0]["icon"].stringValue
        let dt = json["dt"].doubleValue
        let time = NSDate(timeIntervalSince1970: dt)
        let tempKelvin = json["temp"]["day"].doubleValue
        let maxTempKelvin = json["temp"]["max"].doubleValue
        let minTempKelvin = json["temp"]["min"].doubleValue
        let sunRise =  NSDate(timeIntervalSince1970: json["sys"]["sunrise"].doubleValue )
        let sunSet =  NSDate(timeIntervalSince1970: json["sys"]["sunset"].doubleValue )

        let humidity = json["main"]["humidity"].intValue
        let pressure = json["main"]["pressure"].intValue
        let visibility = json["visibility"].doubleValue

        
        return WeatherCondition(
            cityName: name,
            weather: weather,
            icon: IconType(rawValue: icon),
            time: time,
            tempKelvin: tempKelvin,
            maxTempKelvin: maxTempKelvin,
            minTempKelvin: minTempKelvin,
            sunRise: sunRise,
            sunSet: sunSet,
            humidity: humidity,
            pressure: pressure,
            visibility: visibility
        )
    }
    
    
}
