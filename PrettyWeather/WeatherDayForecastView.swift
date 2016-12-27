//
//  WeatherDayForecastView.swift
//  PrettyWeather
//
//  Created by Gosia Szpak on 24.10.2016.
//  Copyright © 2016 Gosia Szpak. All rights reserved.
//

import UIKit
import Cartography
import WeatherIconsKit

class WeatherDayForecastView: UIView {
    
    private var didSetupConstraints = false
    private let iconLabel = UILabel()
    private let dayLabel = UILabel()
    private let tempsLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        style()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func updateConstraints() {
        if didSetupConstraints {
            super.updateConstraints()
            return
        }
        layoutView()
        super.updateConstraints()
        didSetupConstraints = true
    }
    
    func setup(){
        self.addSubview(iconLabel)
        self.addSubview(dayLabel)
        self.addSubview(tempsLabel)
        
    }
    
    func layoutView(){
        
        constrain(self) {
            $0.height == $0.superview!.height
        }
        
        constrain(iconLabel) {
            $0.centerX == $0.superview!.centerX
            $0.top == $0.superview!.top + 5
        }
        
        constrain(dayLabel, iconLabel) {
            $0.centerX == $0.superview!.centerX
            $0.top == $1.bottom + 5
        }
        
        constrain(tempsLabel, dayLabel) {
            $0.centerX == $0.superview!.centerX
            $0.top == $1.bottom + 5
        }
    }
    
    func style(){
        iconLabel.textColor = .white
        
        dayLabel.font = UIFont.latoFont(ofSize: 15)
        dayLabel.textColor = .white
        
        tempsLabel.font = UIFont.latoFont(ofSize: 15)
        tempsLabel.textColor = .white
    }
    
    func render(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEEE"
        dayLabel.text = dateFormatter.string(from: NSDate() as Date)
        iconLabel.attributedText = WIKFontIcon.wiDaySunnyIcon(withSize: 30).attributedString()
        
        tempsLabel.text = "7°     11°"
    }
    
    
    func render(weatherCondition: WeatherCondition){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEEE"
        
        dayLabel.text = dateFormatter.string(from: weatherCondition.time as Date)
        
        
        iconLabel.attributedText = iconStringFromIcon(icon: weatherCondition.icon!, size: 17)
        
        var usesMetric = true
        
        //usesMetric = NSLocale.current.usesMetricSystem

        
        if usesMetric {
            tempsLabel.text = "\(Int(round(weatherCondition.minTempCelcius)))°  \(Int(round(weatherCondition.maxTempCelcius)))°"
        } else {
            tempsLabel.text = "\(Int(round(weatherCondition.minTempFahrenheit)))°  \(Int(round(weatherCondition.maxTempFahrenheit)))°"
        }
    }
    
    
    
    
    
}
