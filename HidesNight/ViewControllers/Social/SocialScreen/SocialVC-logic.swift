//
//  SocialVC-logic.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension SocialVC {
    func getUserFromParent() {
        let parentTab = (self.tabBarController as! TabBarVC)
        self.user = parentTab.user
    }
    
    func loadFriendsAndInvites() {
        let uids = [String](myUtils.mergeDictionaries(d1: self.user.friends, d2: self.user.inbxFrReqs).keys)
        let gameIDs = [String](self.user.inbxGaReqs?.keys ?? [:].keys)
        
        FirebaseAPIClient.getAllUsers(withIDs: uids) { (usrs) in
            FirebaseAPIClient.getAllGames(withIDs: gameIDs, completion: { (games) in
                self.resetAndAdd(games: games)
                self.resetAndAdd(friends: usrs)
                self.reloadTableView()
                self.alerts.triggerCallback()
            })
        }

        
    }
    
    func resetAndAdd(friends: [User]) {
        var replaceRequests: [User] = []
        var replaceFriends: [User] = [self.user]
        
        for friend in friends {
            let friendStatus = categorize(usr: friend)
            if friendStatus == .pending {
                replaceRequests.append(friend)
            } else {
                replaceFriends.append(friend)
            }
        }
        
        tableData[1] = replaceRequests
        tableData[2] = replaceFriends
    }
    
    func resetAndAdd(games: [Game]) {
        tableData[0] = games
    }
    
    func reloadTableView() {
        debugPrint("social feed reloaded")
        debugPrint(tableData)
        updateSectionHeaders()
        friendsTable.reloadData()
    }
    
    func updateSectionHeaders() {
        sectionsToDisplay = []
        for i in 0..<tableData.count {
            let data = tableData[i]
            if data.count > 0 {
                sectionsToDisplay.append(SocialVC.headerNames[i])
            }
        }
    }
    
    
    func categorize(usr: User) -> FRIEND_STATUS {
        if usr == self.user {
            return .currUser
        } else if self.user.friends?.keys.contains(usr.uid) ?? false {
            return .existing
        } else if self.user.sentFrReqs?.keys.contains(usr.uid) ?? false {
            return .pending
        } else if self.user.inbxFrReqs?.keys.contains(usr.uid) ?? false {
            return .pending
        } else {
            return .unknown
        }
    }
    
    func getTableDataFor(section: String) -> [Any]{
        guard let index = SocialVC.headerNames.index(of: section) else {return []}
        return tableData[index]
        
    }

}
