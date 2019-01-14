//
//  Team.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/28/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit

class Team: FirebaseReady, Comparable {
    static func < (lhs: Team, rhs: Team) -> Bool {
        return lhs.uid < rhs.uid
    }
    
    static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    func createPushable() -> [String : Any?] {
        var ret:[String: Any?] = [:]
        ret["name"] = self.name
        ret["members"] = memberIDs
        
        return ret
    }
    
    required init(key: String, record: [String : Any?]) {
        updateThisTeam(key: key, record: record)
    }
    
    var uid: String!
    var name: String!
    var memberIDs = [String: String]()
    var img: UIImage?
    
    init(uid: String, name: String) {
        self.uid = uid
        self.name = name
    }
    
    func updateThisTeam(key: String, record: [String: Any?]) {
        self.uid = key
        self.name = record["name"] as? String ?? ""
        self.memberIDs = record["members"] as? [String: String] ?? [:]
    }
    
    func getMembersOfTeamFrom(game: Game) -> [User] {
        return game.players.filter { (usr) -> Bool in
            self.memberIDs.keys.contains(usr.uid)
        }
    }
    
    func addMember(user: User) {
        self.memberIDs[user.uid] = user.fullname
    }
    
    
}
