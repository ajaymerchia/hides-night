//
//  NotificationsHelper.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/13/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationsHelper {
    static func clearLocalNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [Constants.checkInNotification, Constants.endHideNotification])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [Constants.checkInNotification, Constants.endHideNotification])
        debugPrint("Removed local notifications")
    }
    
    static func setCheckInTimer(everySeconds: Double, gameID: String) {
        let checkInContent = UNMutableNotificationContent()
        checkInContent.body = "Don't forget to check in!"
        checkInContent.categoryIdentifier = NotificationActions.checkIn
        checkInContent.userInfo = ["gameID": gameID]
        
        let checkInTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(everySeconds),
                                                               repeats: true)
        
        let checkInID = Constants.checkInNotification
        let checkInNotif = UNNotificationRequest(identifier: checkInID,
                                                 content: checkInContent, trigger: checkInTrigger)
        UNUserNotificationCenter.current().add(checkInNotif) { (err) in
            if let error = err {
                debugPrint(error)
            }
        }
    }
    
    static func setGameEndTimer(game: Game) {
        guard let seekers = game.currentRound.seeker?.getMembersOfTeamFrom(game: game) else { return }
        guard let endOfHide = game.currentRound.startTime else { return }
        
        setGameEndTimer(withSeekers: seekers.map({ (user) -> String in user.fullname }), endOfHideAt: endOfHide)
        
    }
    
    static func setGameEndTimer(withSeekers: [String], endOfHideAt: Date) {
        let firstNameSeekers = withSeekers.map { (str) -> String in
            return String(str.prefix(while: { (c) -> Bool in
                return c != " "
            }))
        }
        
        let message = "Here " + firstNameSeekers.prefix(upTo: firstNameSeekers.count - 1).joined(separator: ", ") + " and " + firstNameSeekers[firstNameSeekers.count-1] + " come!"
        
        
        let endHideContent = UNMutableNotificationContent()
        endHideContent.title = "Ready or not?"
        endHideContent.body = message
        let endHideTrigger = UNTimeIntervalNotificationTrigger(timeInterval: endOfHideAt.timeIntervalSinceNow, repeats: false)
        let endHideID = Constants.endHideNotification
        let endHideNotif = UNNotificationRequest(identifier: endHideID, content: endHideContent, trigger: endHideTrigger)
        
        UNUserNotificationCenter.current().add(endHideNotif) { (err) in
            if let error = err {
                debugPrint(error)
            }
        }
        
    }
    
    
}
