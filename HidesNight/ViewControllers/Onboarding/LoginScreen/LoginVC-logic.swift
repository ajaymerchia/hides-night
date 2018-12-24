//
//  LoginVC-logic.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/20/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import iosManagers

extension LoginVC {
    @objc func advanceToPW() {
        passwordField.becomeFirstResponder()
    }
    
    @objc func attemptLogin() {
        self.view.isUserInteractionEnabled = false
        guard let username = usernameField.text else {
            alerts.displayAlert(title: "Oops!", message: "Please enter a username.")
            return
        }
        if username == "" {
            alerts.displayAlert(title: "Oops!", message: "Please enter a username.")
            return
        }
        
        guard let password = passwordField.text else {
            alerts.displayAlert(title: "Oops!", message: "Please enter a password.")
            return
        }
        if password == "" {
            alerts.displayAlert(title: "Oops!", message: "Please enter a password.")
            return
        }
        
        hud = alerts.startProgressHud(withMsg: "Logging In")
        
        FirebaseAPIClient.findEmail(forUsername: username, success: { (email) in
            debugPrint("Found Email: ", email)
            FirebaseAPIClient.login(withEmail: email, andPassword: password, success: { (uid) in
                FirebaseAPIClient.getUserForAccount(withId: uid, completion: { (user) in
                    self.pendingUser = user
                    self.pendingLogin = true
                    
                    self.checkForPendingLogin()
                })
            }, fail: {
                self.alerts.displayAlert(title: "Oops!", message: "Your password is incorrect.")
            })
            
        }) {
            self.alerts.displayAlert(title: "Oops!", message: "We couldn't find that username")
        }
        
        
        
    }
    
    
}