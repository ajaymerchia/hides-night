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
    
}

class NotificationActions {
    // Actions
    static let acceptAction: String = "accept"
    static let rejectAction: String = "decline"
    
    // Notification Types
    static let friendRequest: String = "friendRequest"
    static let newFriend: String = "newFriend"
    
    static let gameRequest: String = "gameRequest"

}

enum FRIEND_STATUS {
    case unknown
    case pending
    case selected
    case existing
    case currUser
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
    
    
    // Friend Request Actions
    static let rejectFriendRequest = Notification.Name("rejectFriend")
    static let acceptFriendRequest = Notification.Name("acceptFriend")
    static let viewFriendRequest = Notification.Name("viewFriend")
    
    
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
    
    // Logo
    static let logo_dark: UIImage! = UIImage(named: "logo-alpha")

    // Placeholders
    static let avatar_white: UIImage! = UIImage(named: "avatar-white")
    static let avatar_black: UIImage! = UIImage(named: "avatar-black")
    static let avatar_alpha: UIImage! = UIImage(named: "avatar-alpha")
    static let placeholder: UIImage! = UIImage(named: "white-placeholder")

    // Nav Icons
    static let nav_add_image: UIImage! = UIImage(named: "nav-add-image")
    static let nav_add_person: UIImage! = UIImage(named: "nav-add-person")
    static let nav_remove_person: UIImage! = UIImage(named: "nav-remove-person")
    static let nav_info: UIImage! = UIImage(named: "nav-info")
    static let nav_info_small: UIImage! = UIImage(named: "nav-info-small")
    static let nav_logout: UIImage! = UIImage(named: "nav-logout")
    static let nav_trash: UIImage! = UIImage(named: "nav-trash")
    static let nav_refresh: UIImage! = UIImage(named: "nav-refresh")
    
    // Icon Buttons
    static let mark_check: UIImage! = UIImage(named: "mark-check")
    static let mark_cancel: UIImage! = UIImage(named: "mark-cancel")
    static let mark_chat: UIImage! = UIImage(named: "mark-chat")
    static let mark_play: UIImage! = UIImage(named: "mark-play")
    static let mark_next: UIImage! = UIImage(named: "mark-next")
    static let mark_catch: UIImage! = UIImage(named: "mark-catch")
    static let mark_timer: UIImage! = UIImage(named: "mark-timer")
    
    
}

extension UIFont {
    static let TITLE_FONT = UIFont(name: "LuckiestGuy-Regular", size: 50)
    static let SUBTITLE_FONT = UIFont(name: "LuckiestGuy-Regular", size: 30)
    static let HEADER_FONT = UIFont(name: "LuckiestGuy-Regular", size: 18)
    static let TEXT_ACCENT = UIFont(name: "LuckiestGuy-Regular", size: 14)
    static let BIG_TEXT_FONT = UIFont(name: "Avenir-Heavy", size: 18)
    static let TEXT_FONT = UIFont(name: "Avenir-Heavy", size: 14)
    static let LIGHT_TEXT_FONT = UIFont(name: "Avenir-Book", size: 14)
    
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

extension TimeInterval {
    static let defaultRound = TimeInterval(myUtils.seconds(hr: 1.5))
    static let defaultCheckin = TimeInterval(myUtils.seconds(min: 15))
    static let defaultGPS = TimeInterval(myUtils.seconds(hr: 1))
}


