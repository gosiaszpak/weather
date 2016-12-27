//
//  WeatherHourForecastView.swift
//  PrettyWeather
//
//  Created by Gosia Szpak on 24.10.2016.
//  Copyright © 2016 Gosia Szpak. All rights reserved.
//

import Cartography
import WeatherIconsKit

class WeatherHourForecastView: UIView {

    private var didSetupConstraints = false
    private let iconLabel = UILabel()
    private let hourLabel = UILabel()
    private let tempsLabel = UILabel()

    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
        style()
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

    required init(coder aDecocer: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }

    func style(){
        iconLabel.textColor = .white
        hourLabel.font = UIFont.latoFont(ofSize: 15)
        hourLabel.textColor = .white
        tempsLabel.font = UIFont.latoFont(ofSize: 15)
        tempsLabel.textColor = .white
    }
    
    func setup(){
        self.addSubview(iconLabel)
        self.addSubview(hourLabel)
        self.addSubview(tempsLabel)
    }
    
    func layoutView(){
        
        constrain(iconLabel) {
            $0.centerX == $0.superview!.centerX
            $0.top == $0.superview!.top
        }
        constrain(hourLabel, iconLabel) {
            $0.centerX == $0.superview!.centerX
            $0.top == $1.bottom + 5
        }
        
        constrain(tempsLabel, hourLabel) {
            $0.centerX == $0.superview!.centerX
            $0.top == $1.bottom + 5
        }
        
    }
    
    func render(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        hourLabel.text = dateFormatter.string(from: NSDate() as Date)
        iconLabel.attributedText = WIKFontIcon.wiDaySunnyIcon(withSize: 30).attributedString()
        tempsLabel.text = "5˚ 8˚"
        
    }
    
    
    func render(weatherCondition: WeatherCondition){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        
        hourLabel.text = dateFormatter.string(from: weatherCondition.time as Date)
        
        
        iconLabel.attributedText = iconStringFromIcon(icon: weatherCondition.icon!, size: 17)
        
        var usesMetric = true
        
        //usesMetric = NSLocale.current.usesMetricSystem
        
        if usesMetric {
            
            
            tempsLabel.text = "\(Int(round(weatherCondition.tempCelcius)))°"
        } else {
            tempsLabel.text = "\(Int(round(weatherCondition.tempFahrenheit)))°"
        }
    }

    
}


