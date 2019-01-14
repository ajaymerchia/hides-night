//
//  AppDelegate-notificationDesign.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/11/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import Foundation
import UserNotifications
import Firebase

extension AppDelegate {
    func setUpNotificationStyles() {
        
        // Accept/Reject Requests
        let acceptAction = UNNotificationAction(
            identifier: NotificationActions.acceptAction, title: "Accept",
            options: [.foreground, .authenticationRequired])
        let declineAction = UNNotificationAction(
            identifier: NotificationActions.rejectAction, title: "Decline",
            options: [.foreground, .authenticationRequired, .destructive])
        let checkInAction = UNNotificationAction(identifier: NotificationActions.checkInAction, title: "Check In", options: [.foreground, .authenticationRequired])
        
        
        
        
        let friendRequests = UNNotificationCategory(identifier: NotificationActions.friendRequest, actions: [acceptAction, declineAction], intentIdentifiers: [], options: [])
        let gameRequests = UNNotificationCategory(identifier: NotificationActions.gameRequest, actions: [acceptAction, declineAction], intentIdentifiers: [], options: [])
        
        // New status
        let newFriend = UNNotificationCategory(identifier: NotificationActions.newFriend, actions: [], intentIdentifiers: [], options: [])
        
        // Game Notifications
        let setHideTimer = UNNotificationCategory(identifier: NotificationActions.setHideTimer, actions: [], intentIdentifiers: [], options: [])
        let checkIns = UNNotificationCategory(identifier: NotificationActions.checkIn, actions: [checkInAction], intentIdentifiers: [], options: [])
        
        let newChat = UNNotificationCategory(identifier: NotificationActions.newChat, actions: [], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([friendRequests, gameRequests, newFriend, setHideTimer, checkIns, newChat])
        
    }
}
