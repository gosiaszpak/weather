//
//  WeatherDaysForcastView.swift
//  PrettyWeather
//
//  Created by Gosia Szpak on 24.10.2016.
//  Copyright © 2016 Gosia Szpak. All rights reserved.
//

import UIKit
import Foundation
import Cartography

class WeatherDaysForcastView: UIView, UIScrollViewDelegate {
  
    private var didSetupConstraints = false
    private let scrollView = UIScrollView()
    private let pageControlView = UIView(frame: CGRect.zero)

    
    private var forecastCells = Array<WeatherDayForecastView>()
    private var previousOffset = CGPoint(x:0, y:0)
    
    private var pageControl: UIPageControl = UIPageControl(frame: CGRect( x: 0, y: 0, width: 0, height: 20))
    
    static var HEIGHT: CGFloat {
        get { return 95 }
    }
    
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
        didSetupConstraints = true
    }
    
    func setup(){
        (0..<7).forEach {_ in
            let cell = WeatherDayForecastView(frame: CGRect.zero)
            forecastCells.append(cell)
            scrollView.addSubview(cell)
        }
        
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        
        
        configurePageControl()
        
        scrollView.delegate = self
        
        addSubview(pageControlView)
        addSubview(scrollView)
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * 2, height: self.scrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(changePage), for: .valueChanged)
    }
    
    func changePage(sender: AnyObject) {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
        
        previousOffset.x = x
        
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        var offsetPoint = CGPoint(x: 0, y: 0)
        if(Int(previousOffset.x) == 0)
        {
            offsetPoint = CGPoint(x: scrollView.frame.size.width, y: 0)
            
        }
        
        scrollView.setContentOffset(offsetPoint, animated: true)
        previousOffset = offsetPoint
        
        if(offsetPoint.x == 0){
            pageControl.currentPage = 0
        }
        else {
            pageControl.currentPage = 1
        }
        
    }
    
    
    
    func configurePageControl(){
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.tintColor = .red
        pageControl.pageIndicatorTintColor = UIColor(white: 1, alpha: 0.5)
        pageControl.currentPageIndicatorTintColor = .white
        
        pageControl.hidesForSinglePage = true
        
        
        pageControlView.addSubview(pageControl)
    }

    
    func layoutView() {

        
        constrain(self){
            $0.height == WeatherDaysForcastView.HEIGHT
            
        }
        
        constrain(scrollView){
            $0.top == $0.superview!.top
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
            $0.bottom == $0.superview!.bottom - 20
        }
        
        
        constrain(forecastCells.first!){
            $0.left == $0.superview!.left
        }
        
        constrain(forecastCells.last!){
            $0.right == $0.superview!.right
        }


        for idx in 0..<(forecastCells.count - 1){
            let cell = forecastCells[idx]
            let nextCell = forecastCells[idx + 1]
            constrain(cell, nextCell) {
                $0.right == $1.left + 5
            }
            
        }

        forecastCells.forEach{ cell in
            constrain(cell){
                $0.width == $0.height
                $0.height == $0.superview!.height
                $0.top == $0.superview!.top + 5
            }
        }
        
        constrain(pageControlView) {
            $0.bottom == $0.superview!.bottom
            $0.width == $0.superview!.width
            $0.height == 20
            $0.centerX == $0.superview!.centerX
            
        }
        
        constrain(scrollView, pageControlView) {
            $1.top == $0.bottom
        }

        
    }
    
    func render() {
        forecastCells.forEach{ cell in
            cell.render()
        }
    }
    
    
    func render(weatherConditions: Array<WeatherCondition>){
        zip(forecastCells, weatherConditions).forEach {
            $0.render(weatherCondition: $1)
        }
    }
}
