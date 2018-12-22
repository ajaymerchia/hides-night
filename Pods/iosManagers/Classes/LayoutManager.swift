//
//  LayoutManager.swift
//
//  Created by Ajay Raj Merchia on 10/10/18.
//  Copyright © 2018 Ajay Raj Merchia. All rights reserved.
//

import Foundation
import UIKit

public class LayoutManager {
    public static func belowCentered(elementAbove: UIView, padding: CGFloat, width:CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: elementAbove.frame.midX - width/2, y: elementAbove.frame.maxY + padding, width: width, height: height)
    }
    public static func belowLeft(elementAbove: UIView, padding: CGFloat, width:CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: elementAbove.frame.minX, y: elementAbove.frame.maxY + padding, width: width, height: height)
    }
    public static func belowRight(elementAbove: UIView, padding: CGFloat, width:CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: elementAbove.frame.maxX - width, y: elementAbove.frame.maxY + padding, width: width, height: height)
    }
    
    public static func aboveCentered(elementBelow: UIView, padding: CGFloat, width:CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: elementBelow.frame.midX - width/2, y: elementBelow.frame.minY - (padding+height), width: width, height: height)
    }
    public static func aboveLeft(elementBelow: UIView, padding: CGFloat, width:CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: elementBelow.frame.minX, y: elementBelow.frame.minY - (padding+height), width: width, height: height)
    }
    
    public static func aboveRight(elementBelow: UIView, padding: CGFloat, width:CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: elementBelow.frame.maxX - width, y: elementBelow.frame.minY - (padding+height), width: width, height: height)
    }
    
    public static func between(elementAbove: UIView, elementBelow: UIView, width:CGFloat, topPadding: CGFloat, bottomPadding: CGFloat) -> CGRect {
        
        debugPrint(elementAbove.frame.maxY + topPadding)
        
        return CGRect(x: elementAbove.frame.midX - width/2, y: elementAbove.frame.maxY + topPadding, width: width, height: elementBelow.frame.minY - (elementAbove.frame.maxY + topPadding + bottomPadding))
        
    }
    
    
    
    
}
