//
//  AddFriendVC-logic.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension AddFriendVC: UITextFieldDelegate {
    func getData() {
        self.user = (self.navigationController as! DataNavVC).user
        hud = alerts.startProgressHud(withMsg: "", style: .dark)
        
        self.view.isUserInteractionEnabled = false
        FirebaseAPIClient.getAllAccountInfo { (usrs) in
            self.allUsers = usrs.sorted()
            self.alerts.triggerCallback()
            self.filterResults()
        }
    }
    
    @objc func runFilter(_ sender: UITextField) {
        filterResults()
    }
    
    func filterResults() {
        self.existingContacts = []
        self.searchResults = []
        self.requestsToDisplay = []
        
        guard let str = searchBox.text else {return}
        
        for usr in self.allUsers {
            if matching(str: str, inUsr: usr) {
                switch categorize(usr: usr) {
                case .unknown:
                    self.searchResults.append(usr)
                case .selected:
                    assert(self.requestsToSend.contains(usr))
                    self.requestsToDisplay.append(usr)
                default:
                    self.existingContacts.append(usr)
                }
            } else if self.requestsToSend.contains(usr) {
                self.requestsToDisplay.append(usr)
            }
        }
        
        
        reloadTableview()
    }
    
    func matching(str: String, inUsr: User) -> Bool {
        if str == "" {
            return false // switch to false when done
        }
        
        return (inUsr.first.starts(with: str) || inUsr.last.starts(with: str)) || (inUsr.fullname.contains(str))
    }
    
    func categorize(usr: User) -> FRIEND_STATUS {
        if usr == self.user {
            return .currUser
        } else if self.user.friendIDs?.keys.contains(usr.uid) ?? false {
            return .existing
        } else if self.user.sentFrReqs?.keys.contains(usr.uid) ?? false {
            return .pending
        } else if self.user.inbxFrReqs?.keys.contains(usr.uid) ?? false {
            return .pending
        } else if self.requestsToSend.contains(usr){
            return .selected
        } else {
            return .unknown
        }
    }
    
    
    func updateSectionsHaveRecords() -> Bool {
        let allResults = [self.requestsToDisplay, self.searchResults, self.existingContacts]
        let headerLabels = ["Selected", "People", "Friends"]
        self.sectionsToDisplay = []
        self.compiledResults = []
        
        var hasRecord = false
        
        for i in 0..<(allResults.count) {
            let resultSet = allResults[i]
            if resultSet.count > 0 {
                self.sectionsToDisplay.append(headerLabels[i])
                self.compiledResults.append(resultSet)
                hasRecord = true
                
            }
        }
        
        if self.requestsToSend.count > 0 {
            searchBox.returnKeyType = .send
        } else {
            searchBox.returnKeyType = .done
        }
        searchBox.resignFirstResponder()
        searchBox.becomeFirstResponder()
        
        
        return hasRecord
    }
    
    func reloadTableview() {
        
        let hasRecords = updateSectionsHaveRecords()
        
        if searchBox.text != "" {
            self.setNoResults(to: !hasRecords)
        }
        tableview.reloadData()
    }
    
    @objc func processDoneEditing() {
        if searchBox.returnKeyType == .done {
            searchBox.resignFirstResponder()
        } else {
            sendFriendRequests()
        }
    }
    
    @objc func sendFriendRequests() {
        self.view.isUserInteractionEnabled = false
        hud = alerts.startProgressHud(withMsg: "Sending Friend Requests", style: .dark)
        FirebaseAPIClient.sendFriendRequest(from: self.user, to: self.requestsToSend, completion: {
            self.dismiss(animated: true, completion: nil)
        })
        
        
    }


}
