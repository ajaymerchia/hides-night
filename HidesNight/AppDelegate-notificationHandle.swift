//
//  AppDelegate-notificationHandle.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/11/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import FirebaseAuth

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Handle the Actual Notifications
    
        
        // Called every time a notfication is sent
        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            
            guard let aps = userInfo["aps"] as? [String: AnyObject] else {
                completionHandler(.failed)
                return
            }
            
            if aps["content-available"] as? Int == 1 {
//                debugPrint(aps["category"] as? String)
                debugPrint("i'm gonna execute this code silently now")
                completionHandler(.noData)
            }
            
        }
        
        // Called when action was sent through a notification
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            
            let userInfo = response.notification.request.content.userInfo
            debugPrint("got a response")
            
            guard let aps = userInfo["aps"] as? [String: Any] else {
                completionHandler()
                return
            }
            guard let notificationCategory = aps["category"] as? String else {
                completionHandler()
                return
            }
            
            
            debugPrint(userInfo)
            var payloadData: [String: Any] = [:]
            let action = response.actionIdentifier == UNNotificationDefaultActionIdentifier ? nil : response.actionIdentifier
            
            if let data = userInfo["data"] as? [String: Any] {
                payloadData = data
            }
    
            
            switch notificationCategory {
            case NotificationActions.friendRequest:
                handleFriendRequest(from: payloadData, withAction: action)
            case NotificationActions.newFriend:
                showNewFriend(from: payloadData, withAction: action)
            default:
                debugPrint("No action to perform")
            }
            
            
            completionHandler()
            
        }

    
    func handleFriendRequest(from: [String: Any], withAction: String?) {
        // if logged in, continue
        guard Auth.auth().currentUser != nil else {
            return
        }
        guard let tabVC = self.window?.rootViewController?.presentedViewController as? TabBarVC else {
            return
        }
        tabVC.loadSocial()

        guard let senderID = from["origin"] as? String else {
            return
        }
        guard let action = withAction else {
            NotificationCenter.default.post(Notification(name: .viewFriendRequest, object: self, userInfo: ["friend": senderID]))
            return
        }
        if action == NotificationActions.acceptAction {
            NotificationCenter.default.post(Notification(name: .acceptFriendRequest, object: self, userInfo: ["friend": senderID]))
        } else {
            NotificationCenter.default.post(Notification(name: .rejectFriendRequest, object: self, userInfo: ["friend": senderID]))
        }
    }

    func showNewFriend(from: [String: Any], withAction: String?) {
        guard Auth.auth().currentUser != nil else {
            return
        }
        guard let tabVC = self.window?.rootViewController?.presentedViewController as? TabBarVC else {
            return
        }
        tabVC.loadSocial()
        
        
    }
    
    
}

