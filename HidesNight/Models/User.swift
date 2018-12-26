//
//  User.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/20/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
class User: FirebaseReady, Equatable, Comparable {
    
    
    static func < (lhs: User, rhs: User) -> Bool {
        return lhs.first < rhs.first
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    
    
    
    var uid: String!
    var first: String!
    var last: String!
    var fullname: String {
        return "\(first ?? "") \(last ?? "")"
    }
    var email: String!
    var username: String!
    var profilePic: UIImage?
    
    var gameIDs: [String : String]! // ID-adminID combos of games
    var inbxGaReqs: [String : String]! // ID-adminID combos of games
    
    var friends: [String : String]! // ID-user combos of users
    var sentFrReqs: [String : String]! // ID-user combos of users to whom requests were sent
    var inbxFrReqs: [String : String]! // ID-user combos of users who sent requests
    var hasFriendRequests: Bool {
        return inbxFrReqs.count != 0
    }
    

    
    init(uid: String, first: String, last: String, email: String, username: String) {
        self.uid = uid
        self.first = first
        self.last = last
        self.email = email
        self.username = username
        
        self.gameIDs = [:]
        self.inbxGaReqs = [:]
        
        self.friends = [:]
        self.sentFrReqs = [:]
        self.inbxFrReqs = [:]
    }
    
    required init(key: String, record: [String : Any?]) {
        updateThisUser(key: key, record: record)
    }
    
    func createPushable() -> [String : Any?] {
        var ret:[String: Any?] = [:]
        
        ret["first"]        = self.first
        ret["last"]         = self.last
        ret["username"]     = self.username
        ret["email"]        = self.email
        ret["gameIDs"]      = self.gameIDs
        ret["inbxGaReqs"]   = self.inbxGaReqs
        
        ret["friends"]   = self.friends
        ret["sentFrReqs"]   = self.sentFrReqs
        ret["inbxFrReqs"]   = self.inbxFrReqs
        
        return ret
        
    }
    
    func setProfilePicture(to: UIImage, updateRemote: Bool, completion: @escaping () -> () = {}) {
        profilePic = to
        if updateRemote {
            FirebaseAPIClient.uploadProfileImage(forUsername: self.username, withImage: to, success: completion, fail: {})
        }
    }
    
    func updateThisUser(key: String, record: [String: Any?]) {
        self.uid = key
        self.first      = record["first"] as? String
        self.last       = record["last"] as? String
        self.username   = record["username"] as? String
        self.email      = record["email"] as? String
        self.gameIDs    = record["gameIDs"] as? [String : String] ?? [:]
        self.inbxGaReqs = record["inbxGaReqs"] as? [String : String] ?? [:]
        
        self.friends = record["friends"] as? [String : String] ?? [:]
        self.sentFrReqs = record["sentFrReqs"] as? [String : String] ?? [:]
        self.inbxFrReqs = record["inbxFrReqs"] as? [String : String] ?? [:]
    }
    
    
    
}
