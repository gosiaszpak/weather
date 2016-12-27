//
//  ForecastUpdateView.swift
//  PrettyWeather
//
//  Created by Gosia Szpak on 09.11.2016.
//  Copyright © 2016 Gosia Szpak. All rights reserved.
//

import UIKit
import Cartography
import LatoFont
import WeatherIconsKit

class ForecastUpdateView: UIView {
    
    private var didSetupConstraints = false
    
    let updateForecastLbl = UILabel()
    let updateForecastButton = UIButton()
    let updateForecastButtonView = UIView()
    
    
    
    static var HEIGHT: CGFloat {
        get { return 30 }
    }

    
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
        
        addSubview(updateForecastLbl)
        addSubview(updateForecastButtonView)
        updateForecastButtonView.addSubview(updateForecastButton)
    }
    
    func style(){
        updateForecastLbl.textColor = .white
        updateForecastLbl.font = UIFont.latoFont(ofSize: 12)
        updateForecastLbl.text = "Implement ..."
        updateForecastLbl.textAlignment = .left
        
        
        updateForecastButton.setTitle("\u{21bb}", for: .normal)
        
        //var refreshImage = UIImage(named:  "Command-Refresh1")
        
        
        
        //updateForecastButton.setImage(refreshImage, for: .normal)
        
        updateForecastButton.setTitleColor(.white, for: .normal)
        
        
        
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    func layoutView(){
        
        constrain(updateForecastLbl) {
            $0.centerY == $0.superview!.centerY
            $0.width == 2.0/3.0 * $0.superview!.width
            $0.left == $0.superview!.left + 20
            
        
        }
        
        constrain(updateForecastLbl, updateForecastButtonView) {
            $1.centerY == $1.superview!.centerY
            $1.width == 30
            $1.height == 30
            $1.right == $1.superview!.right - 20
        }
        
        constrain(updateForecastButton){
            $0.edges == $0.superview!.edges
        }
        
        
    }
}
