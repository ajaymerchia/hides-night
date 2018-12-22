//
//  LoginVC-system.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/20/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import iosManagers
import UIKit

extension LoginVC {
    func setupManagers() {
        alerts = AlertManager(view: self, stateRestoration: {
            self.hud.dismiss()
            self.view.isUserInteractionEnabled = true
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(setPendingLogin(_ :)), name: .hasPendingUserLogin, object: nil)
        
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if firstLoad {
            self.animateNewComponents()
            firstLoad = false
        }
        checkForPendingLogin()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        usernameField.text = ""
        passwordField.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    // Segue Out Functions
    @objc func toSignUp() {
        performSegue(withIdentifier: "login2signup", sender: self)
    }

    
    // Segue Out Helpers
    @objc func setPendingLogin(_ notification: Notification) {
        if let data = notification.userInfo as? [String: User] {
            pendingLogin = true
            pendingUser = data["user"]!
        }
    }
    func checkForPendingLogin() {
        debugPrint("Checking for login")
        debugPrint(pendingLogin)
        debugPrint(pendingUser)
        if pendingLogin && (pendingUser != nil) {
            performSegue(withIdentifier: "login2home", sender: self)
        }
    }
    
}
