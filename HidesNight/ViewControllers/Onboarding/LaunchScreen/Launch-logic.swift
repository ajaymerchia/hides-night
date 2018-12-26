//
//  Launch-logic.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/20/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import iosManagers

import FirebaseAuth


extension LaunchVC {
    func checkForAutoLogin() {
//                FirebaseAPIClient.logout() //FIXME: REMOVE WHEN DONE TESTING MANUAL LOGINS
        guard let loggedInUser = Auth.auth().currentUser else {
            self.performSegue(withIdentifier: "launch2login", sender: self)
            return
        }
        print("about to auto login!")
        let alerts = AlertManager(view: self) {
            self.hud?.dismiss()
        }
        
        hud = alerts.startProgressHud(withMsg: "Logging In", style: .dark)
    
        
        
        FirebaseAPIClient.getUserForAccount(withId: loggedInUser.uid) { (usr) in
//            Set Current User, initiate Login, perform Segue
            self.pendingUser = usr
            self.hud?.dismiss()
            self.performSegue(withIdentifier: "launch2home", sender: self)
        }
//        FirebaseAPIClient.getUserBareBones(uid: loggedInUser.uid) { (user) in
//            self.pendingUser = user
//            self.pendingLogin = true
//            self.performSegue(withIdentifier: "login2HUD", sender: self)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tabBarVC = segue.destination as? TabBarVC{
            tabBarVC.user = self.pendingUser
        }
    }
    
}
