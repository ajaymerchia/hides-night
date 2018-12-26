//
//  ExtendedUtils.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    func modified(withAdditionalHue hue: CGFloat, additionalSaturation: CGFloat, additionalBrightness: CGFloat) -> UIColor {
        
        var currentHue: CGFloat = 0.0
        var currentSaturation: CGFloat = 0.0
        var currentBrigthness: CGFloat = 0.0
        var currentAlpha: CGFloat = 0.0
        
        if self.getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentAlpha){
            return UIColor(hue: currentHue + hue,
                           saturation: currentSaturation + additionalSaturation,
                           brightness: currentBrigthness + additionalBrightness,
                           alpha: currentAlpha)
        } else {
            return self
        }
    }
    
    
    
}

class myUtils {
    static func mergeDictionaries(d1: [String: String]?, d2: [String: String]?) -> [String: String] {
        let d1Unwrap: [String: String]! = d1 ?? [:]
        let d2Unwrap: [String: String]! = d2 ?? [:]
        let result: [String: String]! = d1Unwrap.merging(d2Unwrap) { (str1, str2) -> String in
            return str1
        }
        
        return result
        
        
    }
}
