//
//  Utils.swift
//
//  Created by Ajay Raj Merchia on 10/10/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD

public class Utils {
    
   // Backend Stuff
    public static func uuid() -> String {
        return UUID().uuidString
    }
    
    // URL Stuff
    public static func makeURLSafe(_ url: String) -> String{
        return url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    public static func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            print("Opening URL: \(urlString)")
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    public static func getImageFrom(url: String, defaultImg: UIImage, callback: @escaping ((UIImage) -> ())) {
        
        if let imageUrl:URL = URL(string: url) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageUrl)
                DispatchQueue.main.async {
                    if let retrievedImage = data {
                        callback(UIImage(data: retrievedImage)!)
                    }
                    else {
                        callback(defaultImg)
                    }
                }
                
            }
        } else {
            callback(defaultImg)
        }
    }
    
    // Time Management Stuff
    public static func getYYYYMMDDRepr(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
    
    public static func convertToDate(timestring: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.date(from: timestring) ?? nil
    }
    
    public static func days(s: Double) -> Double {
        return s/(24.0*60*60)
    }
    
    static func secs(d: Double) -> Double {
        return d * 24.0 * 60 * 60
    }
    
    
    // JSON Read Stuff
    public static func cleanJSONRead(_ str: String, other: String) -> String {
        if str == "" {
            return other
        }
        return str
    }
    
    // UI Stuff
    
    public enum Side {
        case Top
        case Right
        case Bottom
        case Left
    }
    
    public static func getBorder(forView: UIView, thickness: CGFloat, color: UIColor, side: Side) -> UIView {
        
        let ret = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        ret.backgroundColor = color
        
        switch side {
            case .Top:
                ret.frame = LayoutManager.aboveCentered(elementBelow: forView, padding: thickness, width: forView.frame.width, height: thickness)
                return ret
            case .Right:
                ret.frame = CGRect(x: forView.frame.maxX, y: forView.frame.minY, width: thickness, height: forView.frame.height)
                return ret
            case .Bottom:
                ret.frame = LayoutManager.belowCentered(elementAbove: forView, padding: 0, width: forView.frame.width, height: thickness)
                return ret
            case .Left:
                ret.frame = CGRect(x: forView.frame.minX - thickness, y: forView.frame.minY, width: thickness, height: forView.frame.height)
                return ret
        }
        
    }
    
    
    
    /// Adds the question mark based background image to the given view
    ///
    /// - Parameter given_view: View to which a background image should be added
    public static func addBackgroundImage(givenView: UIView, imgName: String, opacity: CGFloat = 1) {
        let backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: givenView.frame.width, height: givenView.frame.height))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        backgroundImage.image = UIImage(named: imgName)
        backgroundImage.alpha = opacity
        givenView.insertSubview(backgroundImage, at: 0)
    }
    
    public static func generateRandomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    public static func hexToRGB(hex: String) -> [Int] {
        
        var values = [0,0,0]
        
        guard var hexValue = Int(hex.suffix(6), radix: 16) else {
            return values
        }
        
        for i in 0...2 {
            values[2-i] = hexValue % 256
            hexValue = Int(floor(Double(hexValue) / 256.0))
        }
        
        return values
    }
    
    // Math
    
    public static func sum(_ arr: [Int]) -> Int {
        var sum = 0
        for item in arr {
            sum += item
        }
        return sum
    }
    
    public static func pow(b: Int, e: Int) -> Int {
        var ret = 1
        for _ in 1...e {
            ret = ret * b
        }
        
        return ret
        
    }
    
    /// Prints all Fonts that have been loaded into the application
    public static func printFontFamilies() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }
    
}


public extension String
{
    public func toDateTime() -> Date
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss xxx"
        
        //Parse into NSDate
        let dateFromString : Date = dateFormatter.date(from: self)!
        
        //Return Parsed Date
        return dateFromString
    }
}

public extension UIButton {
    public func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
}

