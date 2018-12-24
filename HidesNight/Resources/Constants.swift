//
//  Constants.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/19/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import iosManagers
import NotificationCenter

class Constants {
    // UI Elements
    
}

enum SignupError {
    case NameBlank
    case EmailBlank
    case UsernameBlank
    case PasswordTooShort
    case EmailInvalid
    case EmailInUse
    case UsernameInUse
    case PasswordMatchFail
    case FirebaseSignupError
}

extension Notification.Name {
    static let hasPendingUserLogin = Notification.Name("hasPendingUserLogin")
    static let newImage = Notification.Name("newImage")
}

extension CGFloat {
    static let PADDING: CGFloat = 20
    static let MARGINAL_PADDING: CGFloat = 5
}

extension UIColor {
    static let DARK_BLUE = UIColor.colorWithRGB(rgbValue: 0x000c42)
    static let LIGHT_BLUE = UIColor.colorWithRGB(rgbValue: 0x5070ff)
    static let ACCENT_RED = UIColor.colorWithRGB(rgbValue: 0xe16040)
    static let ACCENT_GREEN = UIColor.colorWithRGB(rgbValue: 0x40e19b)
    static let ACCENT_BLUE = UIColor.colorWithRGB(rgbValue: 0x40c8e1)
    static let offWhite = rgb(200,200,200)
}

extension UIImage {
    static let placeholder: UIImage! = UIImage(named: "white-placeholder")
    static let logo_dark: UIImage! = UIImage(named: "logo-alpha")
    static let avatar_dark: UIImage! = UIImage(named: "avatar-dark")
    static let avatar_black: UIImage! = UIImage(named: "avatar-black")
}

extension UIFont {
    static let TITLE_FONT = UIFont(name: "LuckiestGuy-Regular", size: 50)
    static let SUBTITLE_FONT = UIFont(name: "LuckiestGuy-Regular", size: 30)
    static let HEADER_FONT = UIFont(name: "LuckiestGuy-Regular", size: 18)
    static let TEXT_ACCENT = UIFont(name: "LuckiestGuy-Regular", size: 14)
    static let BIG_TEXT_FONT = UIFont(name: "Avenir-Heavy", size: 18)
    static let TEXT_FONT = UIFont(name: "Avenir-Heavy", size: 14)
    
    public func withTraits(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    public var italic : UIFont {
        return withTraits(.traitItalic)
    }
    
    public var bold : UIFont {
        return withTraits(.traitBold)
    }
}



