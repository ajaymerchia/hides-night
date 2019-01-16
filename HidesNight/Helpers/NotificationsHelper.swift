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
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [Constants.checkInNotification, Constants.endHideNotification, Constants.gpsTriggerNotification, Constants.gameEndNotification])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [Constants.checkInNotification, Constants.endHideNotification, Constants.gpsTriggerNotification, Constants.gameEndNotification])
        debugPrint("Removed local notifications")
    }
    
    
    // CHECKIN BEHAVIOR
    static func setCheckInTimer(everySeconds: Double, gameID: String) {
        let checkInContent = UNMutableNotificationContent()
        checkInContent.body = "Don't forget to check in!"
        checkInContent.categoryIdentifier = NotificationActions.checkIn
        checkInContent.userInfo = ["gameID": gameID]
        
        let checkInTrigger = UNTimeIntervalNotificationTrigger(timeInterval: max(TimeInterval(everySeconds), 60),
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
    
    
    
    
    // END OF HIDING TIMER
    
    static func setEndHideTimer(game: Game) {
        guard let seekers = game.currentRound.seeker?.getMembersOfTeamFrom(game: game) else { return }
        guard let endOfHide = game.currentRound.startTime else { return }
        
        setEndHideTimer(withSeekers: seekers.map({ (user) -> String in user.fullname }), endOfHideAt: endOfHide)
        
    }
    
    static func setEndHideTimer(withSeekers: [String], endOfHideAt: Date) {
        let firstNameSeekers = withSeekers.map { (str) -> String in
            return String(str.prefix(while: { (c) -> Bool in
                return c != " "
            }))
        }
        
        let message = "Here " + firstNameSeekers.prefix(upTo: firstNameSeekers.count - 1).joined(separator: ", ") + " and " + firstNameSeekers[firstNameSeekers.count-1] + " come!"
        
        
        let endHideContent = UNMutableNotificationContent()
        endHideContent.title = "Ready or not?"
        endHideContent.body = message
        let endHideTrigger = UNTimeIntervalNotificationTrigger(timeInterval: max(endOfHideAt.timeIntervalSinceNow, 60), repeats: false)
        let endHideID = Constants.endHideNotification
        let endHideNotif = UNNotificationRequest(identifier: endHideID, content: endHideContent, trigger: endHideTrigger)
        
        UNUserNotificationCenter.current().add(endHideNotif) { (err) in
            if let error = err {
                debugPrint(error)
            }
        }
        
    }
    
    // GPS TIMER
    static func setGPSActivationTimer(game: Game) {
        guard let beginningOfGPS = game.currentRound.startTime?.addingTimeInterval(game.gpsActivation) else { return }
        
        setGPSActivationTimer(gameTitle: game.title, beginningOfGPS: beginningOfGPS)
    }
    
    static func setGPSActivationTimer(gameTitle: String, beginningOfGPS: Date) {
        let gpsTriggerContent = UNMutableNotificationContent()
        
        gpsTriggerContent.title = "Look out!"
        gpsTriggerContent.body = "Location tracking is active for \(gameTitle)"
        let gpsTriggerTrigger = UNTimeIntervalNotificationTrigger(timeInterval: max(beginningOfGPS.timeIntervalSinceNow, 60), repeats: false)
        let gpsTriggerID = Constants.gpsTriggerNotification
        let gpsTriggerNotif = UNNotificationRequest(identifier: gpsTriggerID, content: gpsTriggerContent, trigger: gpsTriggerTrigger)
        
        UNUserNotificationCenter.current().add(gpsTriggerNotif) { (err) in
            if let error = err {
                debugPrint(error)
            }
        }
    }
    
    
    // end of Game Timer
    static func setEndOfGameTimer(game: Game) {
        guard let endOfGame = game.currentRound.startTime?.addingTimeInterval(game.roundDuration) else { return }
        setEndOfGameTimer(roundName: game.currentRound.name, gameTitle: game.title, endOfGame: endOfGame)
    }
    
    static func setEndOfGameTimer(roundName: String, gameTitle: String, endOfGame: Date) {
        let endOfGameContent = UNMutableNotificationContent()
        
        endOfGameContent.body = "\(roundName) of \(gameTitle) has ended."
        let endOfGameTrigger = UNTimeIntervalNotificationTrigger(timeInterval: max(endOfGame.timeIntervalSinceNow, 60), repeats: false)
        let endOfGameID = Constants.gameEndNotification
        let endOfGameNotif = UNNotificationRequest(identifier: endOfGameID, content: endOfGameContent, trigger: endOfGameTrigger)
        
        UNUserNotificationCenter.current().add(endOfGameNotif) { (err) in
            if let error = err {
                debugPrint(error)
            }
        }
    }
    
    
}
