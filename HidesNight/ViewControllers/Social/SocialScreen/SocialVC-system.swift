//
//  SocialVC-system.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers
import SideMenu

extension SocialVC {
    func setupManagers() {
        alerts = AlertManager(view: self, stateRestoration: {
            self.hud?.dismiss()
        })
        NotificationCenter.default.addObserver(self, selector: #selector(updateImage(_ :)), name: .newImage, object: nil)
    }
    
    @objc func updateImage(_ notification: Notification) {
        if let data = notification.userInfo as? [String: UIImage] {
            profilePictureButton.setImage(data["img"]!, for: .normal)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.profilePictureButton.alpha = 1
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if self.sectionsToDisplay.count == 0 {
            hud = alerts.startProgressHud(withMsg: "Loading Friends", style: .dark)
            loadFriendsAndInvites()
        } else {
            FirebaseAPIClient.updateLocalUserData(usr: self.user) {
                self.loadFriendsAndInvites()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.profilePictureButton.alpha = 0
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let navVC = segue.destination as? DataNavVC {
            navVC.user = self.user
            if segue.identifier == "social2friendDetail" {
                navVC.user2 = self.friendSelected
                navVC.isRequest = self.selectedIsRequest
            }
        } else if let gameVC = segue.destination as? GameDetailVC {
            gameVC.user = self.user
            gameVC.game = self.gameSelected
        }
    }

    // Segue Out Functions
    @objc func goToProfile() {
        self.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @objc func goToAddFriend() {
        self.performSegue(withIdentifier: "social2addfriend", sender: self)
    }
    

}
