//
//  rgba.swift
//
//  Created by Ajay Raj Merchia on 9/13/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import UIKit


public extension UIColor {
    
    /**
     Construct a UIColor using an HTML/CSS RGB formatted value and an alpha value
     
     :param: rgbValue RGB value
     :param: alpha color alpha value
     
     :returns: an UIColor instance that represent the required color
     */
    public class func colorWithRGB(rgbValue : UInt, alpha : CGFloat = 1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 255
        let blue = CGFloat(rgbValue & 0xFF) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     Returns a lighter color by the provided percentage
     
     :param: lighting percent percentage
     :returns: lighter UIColor
     */
    public func lighterColor(percent : Double) -> UIColor {
        return colorWithBrightnessFactor(factor: CGFloat(1 + percent));
    }
    
    /**
     Returns a darker color by the provided percentage
     
     :param: darking percent percentage
     :returns: darker UIColor
     */
    public func darkerColor(percent : Double) -> UIColor {
        return colorWithBrightnessFactor(factor: CGFloat(1 - percent));
    }
    
    public func darkMode() -> UIColor {
        return self.colorWithBrightnessFactor(factor: 0.3)
    }
    
    /**
     Return a modified color using the brightness factor provided
     
     :param: factor brightness factor
     :returns: modified color
     */
    public func colorWithBrightnessFactor(factor: CGFloat) -> UIColor {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
        } else {
            return self;
        }
    }
}

/// A Simple class to assist with UI Color theme
public class rgba: UIColor {
    
    /// Easy UI Color creation method
    ///
    /// - Parameters:
    ///   - r: red on a scale from 0 to 255
    ///   - g: green on a scale from 0 to 255
    ///   - b: blue on a scale from 0 to 255
    ///   - a: alpha coeffiecient from 0 to 1
    /// - Returns: UIColor with the given rgba attributes
    public convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) {
        self.init(red: r/255.00, green: g/255.00, blue: b/255.00, alpha: a)
    }
}
public class rgb: UIColor {
    public convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) {
        self.init(red: r/255.00, green: g/255.00, blue: b/255.00, alpha: 1)
    }
}
