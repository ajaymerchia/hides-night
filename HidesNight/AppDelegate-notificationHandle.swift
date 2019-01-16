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
            guard let notificationCategory = aps["category"] as? String else {
                completionHandler(.failed)
                return
            }
            
            var payloadData: [String: Any] = [:]
            if let data = userInfo["data"] as? [String: Any] {
                payloadData = data
            }
            
            
            switch notificationCategory {
            case NotificationActions.setHideTimer:
                setHideTimer(fromData: payloadData)
            case NotificationActions.gameCancelled:
                NotificationsHelper.clearLocalNotifications()
            default:
                debugPrint("invalid notification")
            }
            
            completionHandler(.noData)
            
        }
        
        // Called when action was sent through a notification
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            
            debugPrint("got a response")
            
            // Check for local notification handling
            
            let localIdentifier = response.notification.request.identifier
            let action = response.actionIdentifier == UNNotificationDefaultActionIdentifier ? nil : response.actionIdentifier
            guard let userInfo = response.notification.request.content.userInfo as? [String: Any] else { return; completionHandler()}

            
            switch localIdentifier {
            case Constants.checkInNotification:
                openGame(from: userInfo, withAction: action)
                checkIntoGame(from: userInfo, withAction: action)
            default:
                debugPrint("not a local notification")
            }
            
            
            
            
            
            guard let aps = userInfo["aps"] as? [String: Any] else {
                completionHandler()
                return
            }
            guard let notificationCategory = aps["category"] as? String else {
                completionHandler()
                return
            }
            
            
            var payloadData: [String: Any] = [:]
            
            if let data = userInfo["data"] as? [String: Any] {
                payloadData = data
            }
    
            
            switch notificationCategory {
            case NotificationActions.friendRequest:
                handleFriendRequest(from: payloadData, withAction: action)
            case NotificationActions.newFriend:
                showNewFriend(from: payloadData, withAction: action)
            case NotificationActions.gameStarted:
                NotificationsHelper.clearLocalNotifications()
                openGame(from: payloadData, withAction: action)
            case NotificationActions.setHideTimer:
                openGame(from: payloadData, withAction: action)
            case NotificationActions.newChat:
                newChat(from: payloadData, withAction: action)
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
    
    func openGame(from: [String: Any], withAction: String?) {
        guard Auth.auth().currentUser != nil else {
            return
        }
        guard let tabVC = self.window?.rootViewController?.presentedViewController as? TabBarVC else {
            return
        }
        tabVC.loadGames()
        
        guard let gameID = from["gameID"] as? String else {
            return
        }
        
        NotificationCenter.default.post(Notification(name: .openGame, object: self, userInfo: ["game": gameID]))
    }
    
    func setHideTimer(fromData: [String: Any]) {
        guard let seekers = fromData["seekers"] as? [String] else { return }
        guard let endOfHide = fromData["endOfHide"] as? String else { return }
        let endOfHideDate = endOfHide.toDateTime()
        
        guard let timeToEnd = fromData["timeToEnd"] as? Int else { return }
        guard let timeToCheck = fromData["timeToCheckin"] as? Int else { return }
        guard let timeToGPS = fromData["timeToGPS"] as? Int else { return }
        
        guard let gameID = fromData["gameID"] as? String else { return }
        guard let gameTitle = fromData["gameTitle"] as? String else { return }
        guard let roundName = fromData["roundName"] as? String else { return }
        
        
        NotificationsHelper.setEndHideTimer(withSeekers: seekers, endOfHideAt: endOfHideDate)
        NotificationsHelper.setCheckInTimer(everySeconds: Double(timeToCheck), gameID: gameID)
        NotificationsHelper.setGPSActivationTimer(gameTitle: gameTitle, beginningOfGPS: endOfHideDate.addingTimeInterval(TimeInterval(timeToGPS)))
        NotificationsHelper.setEndOfGameTimer(roundName: roundName, gameTitle: gameTitle, endOfGame: endOfHideDate.addingTimeInterval(TimeInterval(timeToEnd)))
        
    }
    
    func checkIntoGame(from: [String: Any], withAction: String?) {
        guard Auth.auth().currentUser != nil else {
            return
        }
        guard let tabVC = self.window?.rootViewController?.presentedViewController as? TabBarVC else {
            return
        }
        guard let gameID = from["gameID"] as? String else { return }
        
        for game in tabVC.user.games {
            if game.uid == gameID {
                FirebaseAPIClient.checkIn(by: tabVC.user, forGame: game, completion: {})
            }
        }
    }
    
    func newChat(from: [String: Any], withAction: String?) {
        guard Auth.auth().currentUser != nil else {
            return
        }
        guard let tabVC = self.window?.rootViewController?.presentedViewController as? TabBarVC else {
            return
        }
        
        guard let navVCWrapped = tabVC.viewControllers?[0] as? UINavigationController? else { return }
        guard let navVC = navVCWrapped else { return }
        guard let gameID = from["gameID"] as? String else { return }
        
        
        for game in tabVC.user.games {
            if game.uid == gameID {
                _ = myUtils.showChatVCFor(game: game, perspectiveOf: tabVC.user, fromVC: navVC)
            }
        }
        
    }
    
    
    
    
    
}

