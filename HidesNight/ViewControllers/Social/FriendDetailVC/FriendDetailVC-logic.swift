//
//  FriendDetailVC-logic.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/25/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import ARMDevSuite

extension FriendDetailVC {
    func getData() {
        if let navVC = self.navigationController as? DataNavVC {
            self.user = navVC.user
            self.friend = navVC.user2
            self.pendingRequest = navVC.isRequest
        }
    }
    
    @objc func acceptFriendRequest(_ sender: UIButton) {
        imageViewVisible(sender)
        self.view.isUserInteractionEnabled = false
        alerts.startProgressHud(withMsg: "Responding...", style: .dark)
        
        FirebaseAPIClient.acceptFriendRequest(from: self.friend, to: self.user) {
            self.alerts.triggerCallback()
        }
    }
    
    @objc func declineFriendRequest(_ sender: UIButton) {
        imageViewVisible(sender)
        self.view.isUserInteractionEnabled = false
        alerts.startProgressHud(withMsg: "Responding...", style: .dark)
        
        FirebaseAPIClient.rejectFriendRequest(from: self.friend, to: self.user) {
            self.alerts.triggerCallback()
        }
    }
    
    @objc func proposeEndOfFriendship() {
        let actionSheet = UIAlertController(title: "Are You Sure?", message: "You and \(self.friend.first!) will no longer be able to quick invite each other.", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Remove as Friend", style: .destructive, handler: { (action) -> Void in
            self.endFriendship()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Nevermind", style: .cancel, handler: nil))
        actionSheet.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        self.present(actionSheet, animated: true)
    }
    
    func endFriendship() {
        alerts.startProgressHud(withMsg: "Removing Friend...", style: .dark)
        FirebaseAPIClient.endFriendship(of: self.user, and: self.friend) {
            self.alerts.triggerCallback()
        }
    }
    
    


}
