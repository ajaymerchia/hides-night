//
//  InviteFriendVC-logic.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/28/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension InviteFriendVC {
    
    func getDataFromParent() {
        self.user = (self.navigationController as! DataNavVC).user
        self.game = (self.navigationController as! DataNavVC).game
        self.friendsToShow = []
        
        for friend in user.friends.sorted() {
            if !self.game.players.contains(friend) {
                self.friendsToShow.append(friend)
            }
        }
        
    }
    
    @objc func runFilter(_ sender: UITextField) {
        self.searchResults = []
        for friend in self.friendsToShow {
            if matching(str: sender.text!, inUsr: friend) {
                self.searchResults.append(friend)
            }
        }
        
        tableview.reloadData()
    }
    
    func matching(str: String, inUsr: User) -> Bool {
        if str == "" {
            return false // switch to false when done
        }
        return (inUsr.first.starts(with: str) || inUsr.last.starts(with: str)) || (inUsr.fullname.contains(str))
    }
    
    @objc func inviteFriends() {
        hud = alerts.startProgressHud(withMsg: "Sending Invites", style: .dark)
        FirebaseAPIClient.sendGameInvitation(to: self.invitesToSend, forGame: self.game, success: {
            self.succesfulSend = true
            self.alerts.triggerCallback()
        }) {
            self.alerts.triggerCallback()
        }
    }

}
