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
    
    static func showChatVCFor(game: Game, perspectiveOf: User, fromVC: UINavigationController) -> ChatVC {
        let vc = ChatVC()
        vc.game = game
        vc.user = perspectiveOf
        
        if let preloadedChat = game.chat {
            vc.chat = preloadedChat
            vc.loadChats()
            fromVC.pushViewController(vc, animated: true)
            
        } else {
            FirebaseAPIClient.loadChatFor(game: game) { (c) in
                vc.chat = c
                game.chat = c
                vc.loadChats()
                fromVC.pushViewController(vc, animated: true)
            }
        }
        
        return vc
        
        
        
    }
    
    static func mergeDictionaries(d1: [String: String]?, d2: [String: String]?) -> [String: String] {
        let d1Unwrap: [String: String]! = d1 ?? [:]
        let d2Unwrap: [String: String]! = d2 ?? [:]
        let result: [String: String]! = d1Unwrap.merging(d2Unwrap) { (str1, str2) -> String in
            return str1
        }
        
        return result
    }
    
    public static func getMDDYYRepr(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/dd/yy"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
    
    public static func getURLSafeDateFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M-dd-yy"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
    
    public static func getTimeWithAMPM(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
    
    public static func getFormattedDateAndTime(date: Date) -> String {
        return getMDDYYRepr(date: date) + ", " + getTimeWithAMPM(date: date)
    }
    
    public static func getFormattedCountdown(interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: now, to: Date(timeInterval: interval, since: now))!
        
    }
    
    public static func seconds(hr: Double) -> Double {
        return hr * seconds(min: 60)
    }
    
    public static func seconds(min: Double) -> Double {
        return min * 60
    }
}
