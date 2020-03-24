//
//  LoginVC-system.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/20/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import ARMDevSuite
import UIKit

extension LoginVC {
    func setupManagers() {
		alerts = AlertManager(vc: self, defaultHandler: {
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
        alerts.jghud?.dismiss()
        pendingLogin = false
        self.view.isUserInteractionEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tabBar = segue.destination as? TabBarVC {
            tabBar.user = pendingUser
        }
    }
    
    // Segue Out Functions
    @objc func toSignUp() {
        performSegue(withIdentifier: "login2signup", sender: self)
    }
    
    @objc func toInstructions() {
        guard let parentVC = storyboard?.instantiateViewController(withIdentifier: "InstructionsParent") else {return}
        self.present(parentVC, animated: true, completion: nil)
    }

    
    // Segue Out Helpers
    @objc func setPendingLogin(_ notification: Notification) {
        if let data = notification.userInfo as? [String: User] {
            pendingLogin = true
            pendingUser = data["user"]!
        }
    }
    func checkForPendingLogin() {
        debugPrint("Checking for login...")
        if pendingLogin && (pendingUser != nil) {
            debugPrint("Found login for", pendingUser?.username!)
            performSegue(withIdentifier: "login2home", sender: self)
        }
    }
    
}
