//
//  CurrentWeatherView.swift
//  PrettyWeather
//
//  Created by Gosia Szpak on 24.10.2016.
//  Copyright © 2016 Gosia Szpak. All rights reserved.
//

import UIKit
import Cartography
import LatoFont
import WeatherIconsKit



class CurrentWeatherViewFooter: UIView {
    
    // MARK - weather icons
    private let humidityLbl = UILabel()
    private let pressureLbl = UILabel()
    private let visibilityLbl = UILabel()
    
    private let humidityDesc = UILabel()
    private let pressureDesc = UILabel()
    private let visibilityDesc = UILabel()
    
    
    private let humidityValue = UILabel()
    private let pressureValue = UILabel()
    private let visibilityValue = UILabel()
    
    static var HEIGHT: CGFloat {
        get { return 75 }
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
        self.addSubview(humidityLbl)
        self.addSubview(pressureLbl)
        self.addSubview(visibilityLbl)
        self.addSubview(humidityValue)
        self.addSubview(pressureValue)
        self.addSubview(visibilityValue)
        self.addSubview(humidityDesc)
        self.addSubview(pressureDesc)
        self.addSubview(visibilityDesc)
        
        
    }
    
    func style() {
        
        humidityLbl.textColor = .white
        humidityValue.textColor = .white
        humidityValue.font = UIFont.latoLightFont(ofSize: 15)
        humidityDesc.textColor = .white
        humidityDesc.font = UIFont.latoLightFont(ofSize: 15)
        
        
        
        pressureLbl.textColor = .white
        pressureValue.textColor = .white
        pressureValue.font = UIFont.latoLightFont(ofSize: 15)
        pressureDesc.textColor = .white
        pressureDesc.font = UIFont.latoLightFont(ofSize: 15)
        
        
        visibilityLbl.textColor = .white
        visibilityValue.textColor = .white
        visibilityValue.font = UIFont.latoLightFont(ofSize: 15)
        visibilityDesc.textColor = .white
        visibilityDesc.font = UIFont.latoLightFont(ofSize: 15)
        
        
        
    
    }
    
    func render(){
        
        // DUMMY VALUES
        
        //iconLbl.attributedText = WIKFontIcon.wiDaySunnyIcon(withSize: 20).attributedString()
        
    }
    
    func render(weatherCondition: WeatherCondition) {
        
        humidityLbl.attributedText = WIKFontIcon.wiSprinkleIcon(withSize: 20).attributedString()
        pressureLbl.attributedText = WIKFontIcon.wiThermometerIcon(withSize: 20).attributedString()
        visibilityLbl.attributedText = WIKFontIcon.wiFogIcon(withSize: 20).attributedString()
        
        humidityDesc.text = "Humidity"
        pressureDesc.text = "Pressure"
        visibilityDesc.text = "Visibility"
        
        humidityValue.text = "\(weatherCondition.humidity) %"
        pressureValue.text = "\(weatherCondition.pressure) hPa"
        visibilityValue.text = "\(weatherCondition.visibility) m"
        
    }
    
    
    func layoutView(){
        
        constrain(self) {
            $0.height == CurrentWeatherViewFooter.HEIGHT
        }
        
        
        constrain(humidityLbl, humidityDesc, humidityValue){
            guard let superview = $0.superview else {
                print("no superview")
                return
            }
            $0.top == superview.top + 5
            $0.centerX == 1.0/3.0 * superview.centerX
            $1.top == $0.bottom + 2
            $1.centerX == 1.0/3.0 * superview.centerX
            $2.top == $1.bottom + 2
            $2.centerX == 1.0/3.0 * superview.centerX
        }
        
        constrain(pressureLbl, pressureDesc, pressureValue){
            guard let superview = $0.superview else {
                print("no superview")
                return
            }
            $0.top == superview.top + 5
            $0.centerX == superview.centerX
            $1.top == $0.bottom + 2
            $1.centerX == superview.centerX
            $2.top == $1.bottom + 2
            $2.centerX == superview.centerX
        }
        
        constrain(visibilityLbl, visibilityDesc, visibilityValue){
            guard let superview = $0.superview else {
                print("no superview")
                return
            }
            $0.top == superview.top + 5
            $0.centerX == 5.0/3.0 * superview.centerX
            $1.top == $0.bottom + 2
            $1.centerX == 5.0/3.0 * superview.centerX
            $2.top == $1.bottom + 2
            $2.centerX == 5.0/3.0 * superview.centerX
        }
        
    }
}
