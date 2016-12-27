//
//  PrettyWeatherActivityIndicator.swift
//  PrettyWeather
//
//  Created by Gosia Szpak on 14.11.2016.
//  Copyright © 2016 Gosia Szpak. All rights reserved.
//

import UIKit
import Cartography


class PrettyWeatherActivityIndicatorView: UIActivityIndicatorView {
    
    
    private let activityIndicatorBackgroundView = UIView()
    private let loadingLbl = UILabel()
    private let activityIndicatorBackgroundRect = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    
    func runActivityIndicator(_ view: UIView){
        
        view.addSubview(activityIndicatorBackgroundView)
        
        
        activityIndicatorBackgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
        
        
        activityIndicatorBackgroundView.contentMode = .scaleAspectFill
        activityIndicatorBackgroundView.clipsToBounds = true
        activityIndicatorBackgroundView.bounds = view.bounds
        activityIndicatorBackgroundView.frame = view.frame
        
        
        activityIndicatorBackgroundRect.layer.cornerRadius = 8.0
        activityIndicatorBackgroundRect.backgroundColor = .white
        
        activityIndicatorBackgroundRect.center = activityIndicatorBackgroundView.center
        
        
        loadingLbl.text = "Loading ..."
        
        loadingLbl.font  = UIFont.latoFont(ofSize: 20)
        loadingLbl.textColor = .gray
        loadingLbl.textAlignment = .center
        
        
        
        
        activityIndicatorBackgroundView.addSubview(activityIndicatorBackgroundRect)
        activityIndicatorBackgroundRect.addSubview(self)
        activityIndicatorBackgroundRect.addSubview(loadingLbl)
        
        self.isOpaque = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.activityIndicatorViewStyle = .gray
        
        
        constrain(self, loadingLbl)
        {
            $0.left == $0.superview!.left + 20
            $1.left == $0.right + 30
            $0.centerY == $0.superview!.centerY
            $1.centerY == $1.superview!.centerY
        }
        
        
        self.startAnimating()
        
    }
    
    
    func stopActivityIndicator(){
        
        
        let delayInSeconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            
            self.stopAnimating()
            
            self.activityIndicatorBackgroundRect.removeFromSuperview()
            self.loadingLbl.removeFromSuperview()
            self.activityIndicatorBackgroundView.removeFromSuperview()
            
        }
    }


}
