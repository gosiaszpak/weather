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



class CurrentWeatherViewBody: UIView {
    
    // MARK - weather icons
    private let currentHour = UILabel()
    private let currentDate = UILabel()
    private let sunsetTime = UILabel()
    private let sunriseTime = UILabel()
    private let sunsetLbl = UILabel()
    private let sunriseLbl = UILabel()
    
    
    static var HEIGHT: CGFloat {
        get { return 100 }
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
       self.addSubview(currentHour)
       self.addSubview(currentDate)
       self.addSubview(sunsetTime)
       self.addSubview(sunriseTime)
       self.addSubview(sunsetLbl)
       self.addSubview(sunriseLbl)
        
    }
    
    func style() {
    
        currentDate.textColor = .white
        currentHour.textColor = .white
        sunriseTime.textColor = .white
        sunsetTime.textColor = .white
        sunriseLbl.textColor = .white
        sunsetLbl.textColor = .white
        
        
        
        currentDate.textAlignment = .center
        currentHour.textAlignment = .center
        currentHour.font = UIFont.latoLightFont(ofSize: 40)
        currentDate.font = UIFont.latoLightFont(ofSize: 15)
        
        sunriseTime.font = UIFont.latoLightFont(ofSize: 15)
        sunsetTime.font = UIFont.latoLightFont(ofSize: 15)
        
    }
    
    
    func render(weatherCondition: WeatherCondition) {
        
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabels), userInfo: nil, repeats: true)
        
       // Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabels()), userInfo: nil, repeats:true);
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        sunsetTime.text = dateFormatter.string(from: weatherCondition.sunSet as Date)
        sunriseTime.text = dateFormatter.string(from: weatherCondition.sunRise as Date)
        sunriseLbl.attributedText = WIKFontIcon.wiSunriseIcon(withSize: 20).attributedString()
        sunsetLbl.attributedText = WIKFontIcon.wiSunsetIcon(withSize: 20).attributedString()
    }
    
    func updateTimeLabels(){
        
        let date = NSDate() as Date
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        dateFormatter.dateFormat = "HH:mm a"
        
        
        let dateString = dateFormatter.string(from: date)
        
        let myMutableString = NSMutableAttributedString(
            string: dateFormatter.string(from: date)
        )
        
        myMutableString.addAttributes([NSFontAttributeName:UIFont.latoLightFont(ofSize: 15)!], range:  NSRange(location: dateString.characters.count - 2, length: 2))
        currentHour.attributedText = myMutableString
        
        dateFormatter.dateStyle = .full
        currentDate.text = dateFormatter.string(from: date)
    
    }
    
    
    func layoutView(){
        
        constrain(self) {
            $0.height == CurrentWeatherViewBody.HEIGHT
        }
        
        
        constrain(sunriseLbl){
            guard let superview = $0.superview else {
                print("no superview")
                return
            }
            
            $0.top == superview.top + 5
            $0.left == superview.left + 15
            
        }
        
        constrain(sunriseTime){
            guard let superview = $0.superview else {
                print("no superview")
                return
            }
        
            $0.top == superview.top + 8
        }
        
        
        constrain(sunriseTime, sunriseLbl) {
            $0.left == $1.right + 5
            
        }
        
        
        constrain(sunsetTime) {
            guard let superview = $0.superview else {
                print("no superview")
                return
            }
            
            $0.right == superview.right - 15
            $0.top == superview.top + 8
        }
        
        
        
        constrain(sunsetLbl, sunsetTime) {
            guard let superview = $0.superview else {
                print("no superview")
                return
            }
            
            $0.right == $1.left - 5
            $0.top == superview.top + 8
        }

        
        
        
        constrain(currentHour) {
            
            guard let superview = $0.superview else {
                print("no superview")
                return
            }
            
            $0.top == superview.top + 20
            $0.centerX == superview.centerX
        }
        
        constrain(currentDate, currentHour) {
            
            guard let superview = $0.superview else {
                print("no superview")
                return
            }
            
            $0.top == $1.bottom + 5
            $0.centerX == superview.centerX
        }
        
    }
}
