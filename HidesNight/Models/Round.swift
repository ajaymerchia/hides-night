//
//  Round.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/29/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

// Intended to be an object held by a game

import Foundation
import CoreLocation

class Round: Equatable, Comparable, FirebaseReady {
    static func == (lhs: Round, rhs: Round) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    static func < (lhs: Round, rhs: Round) -> Bool {
        return lhs.order < rhs.order
    }
    
    func createPushable() -> [String : Any?] {
        var ret:[String: Any?] = [:]
        ret["name"] = self.name
        ret["order"] = self.order
        
        var boundariesPushable = [[String: Any?]]()
        for boundaryPoint in self.boundaryPoints {
            boundariesPushable.append(boundaryPoint.createPushable())
        }
        ret["boundaries"] = boundariesPushable
        
        ret["active"] = self.active
        ret["start"] = self.startTime?.description
        ret["seeker"] = self.seeker?.uid
        ret["winner"] = self.winner?.uid
        
        var catchesPushable = [String: String]()
        for team in self.teamsCaught {
            catchesPushable[team.uid] = team.name
        }
        ret["caught"] = catchesPushable
        
        var teamLocationsPushable = [String: [String: Any?]]()
        for (uid, location) in self.teamLocations {
            teamLocationsPushable[uid] = location.createPushable()
        }
        ret["teamLocations"] = teamLocationsPushable
        
        
        return ret
    }
    
    init(uid: String, name: String, game: Game) {
        self.uid = uid
        self.name = name
        self.parentGame = game
        self.order = self.parentGame.rounds.count + 1
    }
    
    init(key: String, record: [String : Any?], parentGameWithTeams: Game) {
        updateRound(key: key, record: record, parentGame: parentGameWithTeams)
    }
    
    required init(key: String, record: [String : Any?]) {
        fatalError("Use alternative initializer")
    }
    
    func updateRound(key: String, record: [String: Any?], parentGame: Game) {
        self.uid = key
        self.name = record["name"] as? String ?? ""
        self.order = record["order"] as? Int ?? 0
        
        if let boundaries = record["boundaries"] as? [[String: Any?]] {
            for boundary in boundaries {
                self.boundaryPoints.append(CLLocationCoordinate2D(key: "", record: boundary))
            }
        }
        
        self.parentGame = parentGame
        self.active = record["active"] as? Bool ?? false
        self.startTime = (record["start"] as? String)?.toDateTime()
        self.seeker = self.parentGame.teams[record["seeker"] as? String ?? ""]
        self.winner = self.parentGame.teams[record["winner"] as? String ?? ""]
        
    }
    
    
    // Metadata
    var uid: String!
    var name: String!
    var order: Int!
    var boundaryPoints = [CLLocationCoordinate2D]()
    var parentGame: Game!
    
    // Game State
    var active = false
    var startTime: Date?
    var seeker: Team?
    var winner: Team?
    
    // Team States
    var teamsCaught = [Team]()
    var teamLocations = [String: CLLocationCoordinate2D]()
}

extension CLLocationCoordinate2D: FirebaseReady {
    func createPushable() -> [String : Any?] {
        var ret = [String: Any?]()
        
        ret["lat"] = self.latitude
        ret["lon"] = self.longitude
        
        return ret
    }
    
    init(key: String, record: [String : Any?]) {
        let lat = record["lat"] as! Double
        let lon = record["lon"] as! Double
        
        self.init(latitude: CLLocationDegrees(exactly: lat)!, longitude: CLLocationDegrees(exactly: lon)!)
    }
    
    
}
