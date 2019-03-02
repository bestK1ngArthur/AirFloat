//
//  AppTheme.swift
//  AirFlow-swift
//
//  Created by bestK1ng on 28/02/2019.
//

import UIKit

struct AppTheme {

    static private(set) var current = AppTheme.dark
    
    var baseColor: UIColor
    var backColor: UIColor
    var textColor: UIColor
    var tintColor: UIColor
    var tintTextColor: UIColor
    var barColor: UIColor
    var titleTextColor: UIColor
    
    static var dark: AppTheme {
    
        let darkTheme = AppTheme(baseColor: UIColor(hex: 0x282828),
                                 backColor: UIColor(hex: 0x1E1F22),
                                 textColor: UIColor(hex: 0xFFFFFF),
                                 tintColor: UIColor(hex: 0x9F96FF),
                                 tintTextColor: UIColor(hex: 0x5B648E),
                                 barColor: UIColor(hex: 0x2F3239),
                                 titleTextColor: UIColor(hex: 0xBBC8EB))
        
        return darkTheme
    }
    
    func perform() {
        AppTheme.current = self

        // Setup navigation bar
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = tintTextColor
        UINavigationBar.appearance().barTintColor = baseColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
        
        // Setup status bar
        UIApplication.shared.statusBarStyle = .lightContent
    }
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
}
