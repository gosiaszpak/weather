//
//  CurrentWeatherViewHeader.swift
//  PrettyWeather
//
//  Created by Gosia Szpak on 24.10.2016.
//  Copyright © 2016 Gosia Szpak. All rights reserved.
//

import UIKit
import Cartography
import LatoFont
import WeatherIconsKit



class CurrentWeatherViewHeader: UIView {
    
    // MARK - weather icons
    
    private let weatherLbl = UILabel()
    private let currentTempLbl = UILabel()
    private let currentTempDegreeLbl = UILabel()
    private let minTemp = UILabel()
    private let maxTemp = UILabel()
    
    static var HEIGHT: CGFloat {
        get { return 60 }
    }
    
    private var didSetupConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        style()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) not implemented")
    }
    
    
    override func updateConstraints() {
        if didSetupConstraints {
            super.updateConstraints()
            return
        }
        layoutView()
        super.updateConstraints()
        didSetupConstraints = false
    }
    
    // MARK - setup
    func setup(){
        self.addSubview(weatherLbl)
        self.addSubview(currentTempLbl)
        self.addSubview(currentTempDegreeLbl)
        self.addSubview(minTemp)
        self.addSubview(maxTemp)
    }
    
    func style() {
        
        weatherLbl.font = UIFont.latoLightFont(ofSize: 15)
        weatherLbl.textColor = .white
        currentTempLbl.font = UIFont.latoLightFont(ofSize: 40)
        currentTempLbl.textColor = UIColor.white
        currentTempDegreeLbl.textColor = .white
        currentTempDegreeLbl.font = UIFont.latoLightFont(ofSize: 20)
        
        minTemp.font = UIFont.latoLightFont(ofSize: 15)
        minTemp.textColor = .white
        maxTemp.font = UIFont.latoLightFont(ofSize: 15)
        maxTemp.textColor = .white
        
        
    }
    
    func render(){
        
        // DUMMY VALUES 
        
        //iconLbl.attributedText = WIKFontIcon.wiDaySunnyIcon(withSize: 20).attributedString()
        
        weatherLbl.text = "Sunny"
        
        currentTempLbl.text = "6˚"
        currentTempDegreeLbl.text = "˚C"
        
    }
    
    func render(weatherCondition: WeatherCondition) {
        
        
        
        
        weatherLbl.text = weatherCondition.weather
        
        var usesMetric = true
    
        // TODO - change on real run
        //usesMetric = NSLocale.current.usesMetricSystem
       
        
        
        if usesMetric {
            currentTempLbl.text = "\(Int(round(weatherCondition.tempCelcius)))"
            currentTempDegreeLbl.text = "°C"
            maxTemp.text = "Max: \(Int(round(weatherCondition.maxTempCelcius)))°"
            minTemp.text = "Min: \(Int(round(weatherCondition.minTempCelcius)))°"
            
                    }
        else {
            currentTempLbl.text = "\(Int(round(weatherCondition.tempFahrenheit)))°"
            currentTempDegreeLbl.text = "°F"
            maxTemp.text = "Max: \(Int(round(weatherCondition.maxTempFahrenheit)))°"
            minTemp.text = "Min: \(Int(round(weatherCondition.minTempFahrenheit)))°"
            
        }
    }
    
    
    func layoutView(){
        
        constrain(self) {
            $0.height == CurrentWeatherViewHeader.HEIGHT
            
        }

        
        constrain(currentTempLbl) {
            guard let superview = $0.superview else {
                print("no superview")
                return
                }
            
            $0.top == superview.top + 5
            $0.left == superview.left + 15
        }
        
        constrain( currentTempDegreeLbl, currentTempLbl) {
            $0.left == $1.right + 5
            $0.top == $0.superview!.top + 3
        }
        
       
        
        constrain(weatherLbl){
            $0.right == $0.superview!.right - 15
            $0.top == $0.superview!.top + 5
        }
        
        constrain(minTemp, maxTemp) {
            guard let superview = $0.superview else {
                print("no superview")
                return
            }
            
            $0.bottom == superview.bottom - 8
            $1.bottom == superview.bottom - 8
            
            $1.right == superview.right - 15
            $0.right == $1.left - 15
        }
        
    }
    
   }
