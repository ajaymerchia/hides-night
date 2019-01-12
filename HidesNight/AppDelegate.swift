//
//  AppDelegate.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/19/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit
import IQKeyboardManager
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    var window: UIWindow?
    var deviceToken: String?
    var fcmToken: String?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().disabledToolbarClasses.add(ChatVC.self)
        IQKeyboardManager.shared().disabledDistanceHandlingClasses.add(ChatVC.self)
        IQKeyboardManager.shared().disabledTouchResignedClasses.add(ChatVC.self)
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont.BIG_TEXT_FONT], for: .normal)
        UITextField.appearance().keyboardAppearance = .dark
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        registerForPushNotifications()
        


        return true
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.setUpNotificationStyles()
                self?.getNotificationSettings()
        }
        
    }
    
    func getNotificationSettings() {
        // Verify That we can send remote notifications before registering
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        self.deviceToken = token
        print("Device Token: \(token)")
        

    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.fcmToken = result.token
            }
        }
    }


}



// Design The Notification
extension AppDelegate {
    func setUpNotificationStyles() {
        
        // Accept/Reject Requests
        let acceptAction = UNNotificationAction(
            identifier: NotificationActions.acceptAction, title: "Accept",
            options: [.foreground, .authenticationRequired])
        let declineAction = UNNotificationAction(
            identifier: NotificationActions.rejectAction, title: "Decline",
            options: [.foreground, .authenticationRequired, .destructive])
        
        let friendRequests = UNNotificationCategory(identifier: NotificationActions.friendRequest, actions: [acceptAction, declineAction], intentIdentifiers: [], options: [])
        let gameRequests = UNNotificationCategory(identifier: NotificationActions.gameRequest, actions: [acceptAction, declineAction], intentIdentifiers: [], options: [])
        
        
        UNUserNotificationCenter.current().setNotificationCategories([friendRequests, gameRequests])
        
    }
}

// Handle the Actual Notifications
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Called every time a notfication is sent
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        debugPrint("HI EVERYONE, I GOT A NOTIFICATION FROM SOMEWHERE REMOTE!!!")
        
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        
        if aps["content-available"] as? Int == 1 {
            debugPrint(aps["category"] as? String)
            debugPrint("i'm gonna execute this code silently now")
            completionHandler(.noData)
        }
        
    }
    
    // Called when action was sent through a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        guard let aps = userInfo["aps"] as? [String: Any] else {
            completionHandler()
            return
        }
        guard let notificationCategory = aps["category"] as? String else {
            completionHandler()
            return
        }
        
        
        
        if let data = userInfo["data"] as? [String: Any] {
            if notificationCategory == NotificationActions.friendRequest {
                debugPrint("This is a friend request")
                
                // send behavior to a function to handle the response
                if response.actionIdentifier == NotificationActions.acceptAction {
                    debugPrint(data["accepted"])
                } else if response.actionIdentifier == NotificationActions.rejectAction {
                    debugPrint(data["declined"])
                }
            } else if notificationCategory == NotificationActions.gameRequest {
                debugPrint("This is a game request")
                
                // send behavior to a function to handle the response
                if response.actionIdentifier == NotificationActions.acceptAction {
                    debugPrint(data["accepted"])
                } else if response.actionIdentifier == NotificationActions.rejectAction {
                    debugPrint(data["declined"])
                }
            }
            
        }
        
        completionHandler()
        
    }
}


// App States
extension AppDelegate {
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
