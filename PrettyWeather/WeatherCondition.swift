//
//  WeatherCondition.swift
//  PrettyWeather
//
//  Created by Gosia Szpak on 26.10.2016.
//  Copyright © 2016 Gosia Szpak. All rights reserved.
//

import Foundation
import WeatherIconsKit



func iconStringFromIcon(icon: IconType, size: CGFloat) -> NSAttributedString {
    switch icon {
    case .i01d:
        return WIKFontIcon.wiDaySunnyIcon(withSize: size).attributedString()
    case .i01n:
        return WIKFontIcon.wiNightClear(withSize: size).attributedString()
    case .i02d:
        return WIKFontIcon.wiDayCloudyIcon(withSize: size).attributedString()
    case .i02n:
        return WIKFontIcon.wiNightCloudyIcon(withSize: size).attributedString()
    case .i03d:
        return WIKFontIcon.wiDayCloudyIcon(withSize: size).attributedString()
    case .i03n:
        return WIKFontIcon.wiNightCloudyIcon(withSize: size).attributedString()
    case .i04d:
        return WIKFontIcon.wiCloudyIcon(withSize: size).attributedString()
    case .i04n:
        return WIKFontIcon.wiCloudyIcon(withSize: size).attributedString()
    case .i09d:
        return WIKFontIcon.wiDayShowersIcon(withSize: size).attributedString()
    case .i09n:
        return WIKFontIcon.wiNightShowersIcon(withSize: size).attributedString()
    case .i10d:
        return WIKFontIcon.wiDayRain(withSize: size).attributedString()
    case .i10n:
        return WIKFontIcon.wiNightRain(withSize: size).attributedString()
    case .i11d:
        return WIKFontIcon.wiDayThunderstormIcon(withSize: size).attributedString()
    case .i11n:
        return WIKFontIcon.wiNightThunderstormIcon(withSize: size).attributedString()
    case .i13d:
        return WIKFontIcon.wiSnow(withSize: size).attributedString()
    case .i13n:
        return WIKFontIcon.wiSnow(withSize: size).attributedString()
    case .i50d:
        return WIKFontIcon.wiFogIcon(withSize: size).attributedString()
    case .i50n:
        return WIKFontIcon.wiFogIcon(withSize: size).attributedString()
    }
}

enum IconType: String {
    case i01d = "01d"
    case i01n = "01n"
    case i02d = "02d"
    case i02n = "02n"
    case i03d = "03d"
    case i03n = "03n"
    case i04d = "04d"
    case i04n = "04n"
    case i09d = "09d"
    case i09n = "09n"
    case i10d = "10d"
    case i10n = "10n"
    case i11d = "11d"
    case i11n = "11n"
    case i13d = "13d"
    case i13n = "13n"
    case i50d = "50d"
    case i50n = "50n"
}

struct WeatherCondition {
    
    let cityName: String?
    let weather: String
    let icon: IconType?
    let time: NSDate
    let tempKelvin: Double
    let maxTempKelvin: Double
    let minTempKelvin: Double
    let sunRise: NSDate
    let sunSet: NSDate
    let humidity: Int
    let pressure: Int
    let visibility: Double
    
    var tempFahrenheit: Double {
        get { return tempCelcius * 9.0/5.0 + 32.0 }
    }
    
    var minTempFahrenheit: Double {
        get { return minTempCelcius * 9.0/5.0 + 32.0 }
    }
    
    var maxTempFahrenheit: Double {
        get { return maxTempCelcius * 9.0/5.0 + 32.0 }
    }
    
    var tempCelcius: Double {
        get { return tempKelvin - 273.15 }
    }
    
    var minTempCelcius: Double {
        get { return minTempKelvin - 273.15 }
    }
    
    var maxTempCelcius: Double {
        get { return maxTempKelvin - 273.15 }
    }
}
