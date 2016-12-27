//
//  CurrentWeatherViewIcon.swift
//  PrettyWeather
//
//  Created by Gosia Szpak on 24.10.2016.
//  Copyright © 2016 Gosia Szpak. All rights reserved.
//

import UIKit
import Cartography
import LatoFont
import WeatherIconsKit



class CurrentWeatherViewIcon: UIView {
    
    // MARK - weather icons
    private let iconLbl = UIImageView()
    
    static var HEIGHT: CGFloat {
        get { return 75 }
    }
    
    private var didSetupConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
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
        self.addSubview(iconLbl)
           }
    
   
    func render(weatherCondition: WeatherCondition) {
        
     iconLbl.image =  UIImage(named: weatherCondition.icon!.rawValue)
        
    }
    
    
    func layoutView(){
        
        constrain(self) {
            $0.height == CurrentWeatherViewIcon.HEIGHT
            $0.width == CurrentWeatherViewIcon.HEIGHT
        }
    
        constrain(iconLbl){
            $0.centerX == $0.superview!.centerX
            $0.top == $0.superview!.top
            $0.width == 72.0
            $0.height == 72.0
        }
    }
}
