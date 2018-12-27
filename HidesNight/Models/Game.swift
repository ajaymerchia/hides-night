//
//  Game.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/20/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
class GameSelectionType {
    static let Assigned = GameSelectionType(repr: "Assigned")
    static let Chosen = GameSelectionType(repr: "Chosen")
    static let Randomized = GameSelectionType(repr: "Randomized")
    
    var description: String
    
    init(repr: String) {
        description = repr
    }
    
    
}

class Game: FirebaseReady {
    let uid: String!
    let admin: String!
    
    init(gameid: String, admin: User) {
        self.uid = gameid
        self.admin = admin.username
    }
    func createPushable() -> [String : Any?] {
        var ret:[String: Any?] = [:]
        ret["admin"] = self.admin
        
        return ret
    }
    
    required init(key: String, record: [String : Any?]) {
        self.uid = key
        self.admin = record["admin"] as? String
    }
    
    
    
    
}
