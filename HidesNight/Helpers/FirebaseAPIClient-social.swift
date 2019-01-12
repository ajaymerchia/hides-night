//
//  FirebaseAPIClient-social.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

extension FirebaseAPIClient {
    // Finding Friends
    static func getAllAccountInfo(callback: @escaping ([User]) -> ()) {
        let userRef = Database.database().reference().child("users")
        userRef.observeSingleEvent(of: .value) { (snap) in
            guard let allUsers = snap.value as? [String: [String: Any?]] else {
                return
            }
            
            var allAccounts: [User] = []
            
            for (uid, data) in allUsers {
                allAccounts.append(User(key: uid, record: data))
            }
            
            callback(allAccounts)
        }
    }
    
    static func sendFriendRequest(from: User, to: [User], completion: @escaping () -> ()) {
        var usersNeedingUpdates = [from]
        for recip in to {
            from.sentFrReqs?[recip.uid] = recip.fullname
            recip.inbxFrReqs?[from.uid] = from.fullname
            
            usersNeedingUpdates.append(recip)
        }
        
        var values: [String: [String : Any?]] = [:]
        
        for usr in usersNeedingUpdates {
            values[usr.uid] = usr.createPushable()
        }
        
        Database.database().reference().child("users").updateChildValues(values) { (err, ref) in
            completion()
        }
    }
    
    static func rejectFriendRequest(from: User, to: User, completion: @escaping () -> ()) {
        // Remove From Inbox
        // Remove From Outbox
        from.sentFrReqs?.removeValue(forKey: to.uid)
        to.inbxFrReqs?.removeValue(forKey: from.uid)
        
        
        let userNode = Database.database().reference().child("users")
        let values = [from.uid: from.createPushable(), to.uid: to.createPushable()]
        userNode.updateChildValues(values) { (err, ref) in
            completion()
        }
    }
    
    static func acceptFriendRequest(from: User, to: User, completion: @escaping () -> ()) {
        
        from.sentFrReqs?.removeValue(forKey: to.uid)
        to.inbxFrReqs?.removeValue(forKey: from.uid)
        
        from.friendIDs[to.uid] = to.fullname
        to.friendIDs[from.uid] = from.fullname
        
        
        let userNode = Database.database().reference().child("users")
        let values = [from.uid: from.createPushable(), to.uid: to.createPushable()]
        userNode.updateChildValues(values) { (err, ref) in
            completion()
        }
    }
    
    static func endFriendship(of: User, and: User, completion: @escaping () -> ()) {
        of.friendIDs?.removeValue(forKey: and.uid)
        and.friendIDs?.removeValue(forKey: of.uid)
        
        
        let userNode = Database.database().reference().child("users")
        let values = [of.uid: of.createPushable(), and.uid: and.createPushable()]
        userNode.updateChildValues(values) { (err, ref) in
            completion()
        }
    }
    
}
