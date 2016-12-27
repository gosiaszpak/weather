//
//  PrettyWeatherViewController.swift
//  PrettyWeather
//
//  Created by Gosia Szpak on 21.10.2016.
//  Copyright © 2016 Gosia Szpak. All rights reserved.
//

import UIKit
import Cartography
import FXBlurView
import FlickrKit


extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape
    }
    
    func customOval(rect: CGRect) {
        let ovalPath = UIBezierPath(ovalIn: rect)
        
        let shape = CAShapeLayer()
        shape.path = ovalPath.cgPath
        self.layer.mask = shape
    }
}

enum Status {
    case pending
    case error
    case ok
}

struct ResponseStatus {
    var CurrentWeatherForecast = Status.pending
    var HourlyWeatherForecast = Status.pending
    var DailyWeatherForecast = Status.pending
    
    mutating func setCurrentWeatherForecast(status: Status){
        CurrentWeatherForecast = status
    }
    
    mutating func setHourlyWeatherForecast(status: Status){
        HourlyWeatherForecast = status
    }
    
    mutating func setDailyWeatherForecast(status: Status){
        DailyWeatherForecast = status
    }
    
    mutating func setAll(status: Status) {
        CurrentWeatherForecast = status
        HourlyWeatherForecast = status
        DailyWeatherForecast = status
    }
    
    func checkResponseStatus() -> Bool {
        for rStatus in [CurrentWeatherForecast, HourlyWeatherForecast, DailyWeatherForecast] {
            if rStatus == Status.pending {
                return true
            }
        }
        
        for rStatus in [CurrentWeatherForecast, HourlyWeatherForecast, DailyWeatherForecast] {
            if rStatus == Status.error {
                return false
            }
        }
        return true
    }
}



class PrettyWeatherViewController: UIViewController, UIScrollViewDelegate {
    
    static var INSET: CGFloat { get { return 20 } }
    static var RADIUS: CGFloat { get {return 10.0 } }
    
    private let activityIndicator = PrettyWeatherActivityIndicatorView()
        
    private let backgroundView = UIImageView()
    private let scrollView = UIScrollView()
    
    private let currentWeatherViewDecor = UIView(frame: CGRect.zero)
    private let currentWeatherViewIcon = CurrentWeatherViewIcon(frame: CGRect.zero)
    private let currentWeatherViewHeader = CurrentWeatherViewHeader(frame: CGRect.zero)
    private let currentWeatherViewBody = CurrentWeatherViewBody(frame: CGRect.zero)
    private let currentWeatherViewFooter = CurrentWeatherViewFooter(frame: CGRect.zero)
    
    private let hourlyWeatherViewLbl = UILabel(frame: CGRect.zero)
    private let hourlyForecastView = WeatherHourlyForcastView(frame: CGRect.zero)
    
    private let daysWeatherViewLbl = UILabel(frame: CGRect.zero)
    private let daysForecastView = WeatherDaysForcastView(frame: CGRect.zero)
    
    private let forecastUpdateView = ForecastUpdateView(frame: CGRect.zero)
    
    private var locationDatastore: LocationDatastore?
    
    var prettyWeatherResponseStatus = ResponseStatus()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        
        setup()
        layoutView()
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        style()
        render(image: UIImage(named: "DefaultImage"))
        
    }
    
        
        
    
    func refreshWeatherForecast(){
        
         prettyWeatherResponseStatus.setAll(status: Status.pending)
        
        locationDatastore = LocationDatastore(errorClosure: {
            errorMessage in
        
            if let msg = errorMessage {
                let alert = UIAlertController(title: "Failed to find current location", message: msg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Refresh", style: UIAlertActionStyle.default, handler: { action in
                    self.refreshWeatherForecast()
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }
        
        }) { [weak self] location in
            
            
            FlickrDatastore().retrieveImageAtLat(lat: location.lat, lon: location.lon){ image in
                self!.render(image: image)
            }
            
            
            let weatherDatastore = WeatherDatastore()
            
            
            
            weatherDatastore.retrieveCurrentWeatherAtLat(lat: location.lat, lon: location.lon, block: { currentWeatherConditions in
                
                self?.activityIndicator.stopActivityIndicator()
                
                self?.renderCurrentWeatherConditions(weatherConditions: currentWeatherConditions)
                self?.prettyWeatherResponseStatus.setCurrentWeatherForecast(status: Status.ok)
                self?.setUpdateForecastDate()
                return
             }) {
                 error in
                 self?.activityIndicator.stopActivityIndicator()
                 self?.prettyWeatherResponseStatus.setCurrentWeatherForecast(status: Status.error)
                    if self?.prettyWeatherResponseStatus.checkResponseStatus() == false {
                        self?.displayRefreshForecastAlert()
                    }
                }
            
            weatherDatastore.retrieveHourlyForecastAtLat(lat: location.lat, lon: location.lon, block: { hourlyWeatherConditions in
                self?.activityIndicator.stopActivityIndicator()
                self?.renderHourlyWeatherConditions(weatherConditions: hourlyWeatherConditions)
                self?.prettyWeatherResponseStatus.setHourlyWeatherForecast(status: Status.ok)
                return
            }) {
                error in
                self?.activityIndicator.stopActivityIndicator()
                self?.prettyWeatherResponseStatus.setHourlyWeatherForecast(status: Status.error)
                if self?.prettyWeatherResponseStatus.checkResponseStatus() == false {
                    self?.displayRefreshForecastAlert()
                }
            }
            
            weatherDatastore.retrieveDailyForecastAtLat(lat: location.lat, lon: location.lon, dayCnt: 7, block: {dailyWeatherConditions in
                self?.activityIndicator.stopActivityIndicator()
                
                
                self?.renderDailyWeatherConditions(weatherCondiotions: dailyWeatherConditions)
                self?.prettyWeatherResponseStatus.setDailyWeatherForecast(status: Status.ok)
                return
            }) {
                error in
                self?.activityIndicator.stopActivityIndicator()
                self?.prettyWeatherResponseStatus.setDailyWeatherForecast(status: Status.error)
                if self?.prettyWeatherResponseStatus.checkResponseStatus() == false {
                    self?.displayRefreshForecastAlert()
                }
            }
            
        }
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshWeatherForecast()
    }
    
    
    func displayRefreshForecastAlert(){
        
        let alert = UIAlertController(title: "Faild to refresh weather forecast.", message: "An error occurred during a call to http://openweathermap.org/", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Refresh", style: UIAlertActionStyle.default, handler: {
        action in
            self.refreshWeatherForecast()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    func renderCurrentWeatherConditions(weatherConditions: WeatherCondition) {
        currentWeatherViewIcon.render(weatherCondition: weatherConditions)
        currentWeatherViewHeader.render(weatherCondition: weatherConditions)
        currentWeatherViewBody.render(weatherCondition: weatherConditions)
        currentWeatherViewFooter.render(weatherCondition: weatherConditions)
    }
    
    func renderHourlyWeatherConditions(weatherConditions: Array<WeatherCondition>) {
        hourlyForecastView.render(weatherConditions: weatherConditions)

    }
    
    func renderDailyWeatherConditions(weatherCondiotions: Array<WeatherCondition>) {
        daysForecastView.render(weatherConditions: weatherCondiotions)
    }
    
    
    func setup() {
        
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.clipsToBounds = true
        backgroundView.bounds = view.bounds
        backgroundView.frame = view.frame
        
        view.addSubview(backgroundView)
    
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.addSubview(currentWeatherViewDecor)
        scrollView.addSubview(currentWeatherViewIcon)
        scrollView.addSubview(currentWeatherViewHeader)
        scrollView.addSubview(currentWeatherViewBody)
        scrollView.addSubview(currentWeatherViewFooter)
        
        scrollView.addSubview(hourlyWeatherViewLbl)
        scrollView.addSubview(hourlyForecastView)
        
        scrollView.addSubview(daysWeatherViewLbl)
        scrollView.addSubview(daysForecastView)
        
        scrollView.addSubview(forecastUpdateView)
        
        
        
        forecastUpdateView.updateForecastButton.addTarget(self, action: #selector(handleRefreshWeatherForecast), for: .touchUpInside)
        
        
        /* we want to detect to change position of scrolling */
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        
    }
    
    func rotateWheel() {
        //set your angle here
        
        //forecastUpdateView.updateForecastButton.transform  = CGAffineTransform(rotationAngle: (180.0 * CGFloat(M_PI)) / 180.0)

        forecastUpdateView.updateForecastButton.transform = forecastUpdateView.updateForecastButton.transform.rotated(by: CGFloat(-5))
        
    }
        
    
    
    func handleRefreshWeatherForecast(){
        
       let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(PrettyWeatherViewController.rotateWheel), userInfo: nil, repeats: true)
        
       
        
        let delayInSeconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            timer.invalidate()
            
            self.activityIndicator.runActivityIndicator(self.view)
            self.refreshWeatherForecast()
            self.setUpdateForecastDate()
        }
        
       
    }
    
    
    func setUpdateForecastDate(){
        
        let date = NSDate() as Date
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        
        dateFormatter.dateFormat = "MMM dd, yyyy   HH:mm a"
        let dateString = dateFormatter.string(from: date)
        
        forecastUpdateView.updateForecastLbl.text = "Last updated on \(dateString)"
        
    }
    
    func layoutView() {
        
        constrain(backgroundView) { view in
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.left == view.superview!.left
            view.right == view.superview!.right
            
            view.edges == view.superview!.edges
            
        }
        
        constrain(scrollView) {
            $0.edges == $0.superview!.edges
        }
        
        constrain(currentWeatherViewHeader) {
            $0.width == $0.superview!.width - 20
            $0.centerX == $0.superview!.centerX
        }
        
        let currentWeatherInsect: CGFloat = view.frame.height - (CurrentWeatherViewHeader.HEIGHT + CurrentWeatherViewBody.HEIGHT + CurrentWeatherViewFooter.HEIGHT) - PrettyWeatherViewController.INSET
        
        constrain(currentWeatherViewIcon) {
             $0.top == $0.superview!.top + currentWeatherInsect - CurrentWeatherViewIcon.HEIGHT/2.0 + 15
             $0.centerX == $0.superview!.centerX
        }
        
        
        
        constrain(currentWeatherViewHeader) {
            $0.top == $0.superview!.top + currentWeatherInsect + 15
        }
        
        
        constrain(currentWeatherViewBody) {
            $0.width == $0.superview!.width - 20
            $0.centerX == $0.superview!.centerX
            
        }
        
        constrain(currentWeatherViewBody, currentWeatherViewHeader) {
             $0.top == $1.bottom + 0.5
        }
        
        constrain(currentWeatherViewDecor, currentWeatherViewIcon, currentWeatherViewHeader) {
            $0.top == $1.top
            $0.bottom == $2.top
            $0.width == 1.0/2.0 * $2.width
            $0.centerX == $0.superview!.centerX
        }
        
        constrain(currentWeatherViewFooter){
            $0.width == $0.superview!.width - 20
            $0.centerX == $0.superview!.centerX
        }
        
        constrain(currentWeatherViewFooter, currentWeatherViewBody){
            $0.top == $1.bottom + 0.5
            
            
        }

        
        constrain(hourlyForecastView, currentWeatherViewFooter, hourlyWeatherViewLbl){
            $2.top == $1.bottom + 5
            $2.height == 20
            $0.top == $2.bottom
            $2.left == $0.superview!.left + 10
            $2.width == 1.0/3.0 * $0.superview!.width
            $0.width == $0.superview!.width - 20
            $0.centerX == $0.superview!.centerX
            
        }

        constrain(daysForecastView, hourlyForecastView, daysWeatherViewLbl) {
            $2.top == $1.bottom + 5
            $2.height == 20
            $0.top == $2.bottom
            $2.left == $0.superview!.left + 10
            $2.width == 1.0/3.0 * $0.superview!.width
            
            $0.width == $0.superview!.width - 20
            
            /*
             the bottom of daysForecastView is connected to the bottom of scrollView;
             as a result, it enlarges Content View and makes the view scrollable.
             */
            
            
            $0.centerX == $0.superview!.centerX
            $0.height == WeatherDaysForcastView.HEIGHT
        }
        
        constrain(forecastUpdateView, daysForecastView){
            $0.height == ForecastUpdateView.HEIGHT
            $0.top == $1.bottom + 0.5
            $0.centerX == $0.superview!.centerX
            $0.width == $0.superview!.width - 20
            $0.bottom == $0.superview!.bottom - PrettyWeatherViewController.INSET
        }
        
    }
    
    func render(image: UIImage?){
        guard let image = image else { return }
            backgroundView.image = image
        
    }
    
    
    // IMPORTANT - run render in controller
    
    func renderSubviews() {
        currentWeatherViewHeader.render()
        hourlyForecastView.render()
        daysForecastView.render()
    }
    
    func style() {
        

        
        
        currentWeatherViewIcon.layer.zPosition = 1
        
        currentWeatherViewDecor.backgroundColor = UIColor(white: 0, alpha: 0.7)
        currentWeatherViewDecor.customOval(rect: CGRect(x: 0, y: 0, width: currentWeatherViewDecor.frame.width, height:100))
        
        currentWeatherViewHeader.backgroundColor = UIColor(white: 0, alpha: 0.7)
        currentWeatherViewHeader.roundCorners(corners: [.topLeft, .topRight], radius: PrettyWeatherViewController.RADIUS)
        
        currentWeatherViewBody.backgroundColor = UIColor(white: 0, alpha: 0.7)
        currentWeatherViewFooter.backgroundColor = UIColor(white: 0, alpha: 0.7)
       
        
        hourlyWeatherViewLbl.font = UIFont.latoLightItalicFont(ofSize: 15)
        hourlyWeatherViewLbl.textColor = .white
        hourlyWeatherViewLbl.textAlignment = .center
        hourlyWeatherViewLbl.text = "Today"
        hourlyWeatherViewLbl.backgroundColor  = UIColor(white: 0, alpha: 0.7)
        hourlyWeatherViewLbl.roundCorners(corners: [.topLeft, .topRight], radius: PrettyWeatherViewController.RADIUS)
        
        
        hourlyForecastView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        hourlyForecastView.roundCorners(corners: [.topRight], radius: PrettyWeatherViewController.RADIUS)
        
        
        daysWeatherViewLbl.font = UIFont.latoLightItalicFont(ofSize: 15)
        daysWeatherViewLbl.textColor = .white
        daysWeatherViewLbl.textAlignment = .center
        daysWeatherViewLbl.text = "Next days"
        daysWeatherViewLbl.backgroundColor  = UIColor(white: 0, alpha: 0.7)
        daysWeatherViewLbl.roundCorners(corners: [.topLeft, .topRight], radius: PrettyWeatherViewController.RADIUS)
        
        
        daysForecastView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        daysForecastView.roundCorners(corners: [.topRight], radius: PrettyWeatherViewController.RADIUS)
        
        forecastUpdateView.backgroundColor = UIColor(white: 0, alpha: 0.7)
    }
    

}
