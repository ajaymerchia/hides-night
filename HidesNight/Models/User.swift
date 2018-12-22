//
//  User.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/20/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
class User: FirebaseReady {
    
    
    
    var uid: String!
    var first: String!
    var last: String!
    var fullname: String {
        return "\(first ?? "") \(last ?? "")"
    }
    var email: String!
    var username: String!
    var profilePic: UIImage?
    
    var gameIDs: [String]!
    
    init(uid: String, first: String, last: String, email: String, username: String) {
        self.uid = uid
        self.first = first
        self.last = last
        self.email = email
        self.username = username
        self.gameIDs = []
    }
    
    required init(key: String, record: [String : Any?]) {
        self.uid = key
        self.first = record["first"] as? String
        self.last = record["last"] as? String
        self.username = record["username"] as? String
        self.email = record["email"] as? String
        self.gameIDs = record["gameIDs"] as? [String]
        
    }
    
    func createPushable() -> [String : Any?] {
        var ret:[String: Any?] = [:]
        
        ret["first"] = self.first
        ret["last"] = self.last
        ret["username"] = self.username
        ret["email"] = self.email
        ret["gameIDs"] = self.gameIDs
        
        return ret
        
    }
    
    func setProfilePicture(to: UIImage, updateRemote: Bool, completion: @escaping () -> () = {}) {
        profilePic = to
        if updateRemote {
            FirebaseAPIClient.uploadProfileImage(forUsername: self.username, withImage: to, success: completion, fail: {})
        }
    }
    
    
    
}
