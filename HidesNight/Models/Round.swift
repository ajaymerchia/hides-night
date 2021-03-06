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
        ret["status"] = self.roundStatus.description
        
        ret["start"] = self.startTime?.description
        ret["startHide"] = self.startHide?.description
        ret["hideTime"] = self.hidingTime.magnitude
        
        ret["seeker"] = self.seeker?.uid
        
        ret["caught"] = self.teamsCaught
        
        var teamLocationsPushable = [String: [String: Any?]]()
        for (uid, location) in self.teamLocations {
            teamLocationsPushable[uid] = location.createPushable()
        }
        ret["teamLocations"] = teamLocationsPushable
        
        
        
        
        ret["teamCheckins"] = self.teamCheckins.mapValues { (date) -> String in return date.description}
        
        
        
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
        self.startHide = (record["startHide"] as? String)?.toDateTime()
        self.hidingTime = TimeInterval(record["hideTime"] as? Int ?? (15 * 60))
        
        self.seeker = self.parentGame.teams[record["seeker"] as? String ?? ""]
        
        
        
        if let storedStatus = record["status"] as? String {
            for possibleStatus in RoundStatus.states {
                if possibleStatus.description == storedStatus {
                    self.roundStatus = possibleStatus
                    break
                }
            }
        }
        
        
        self.teamsCaught = record["caught"] as? [String: String] ?? self.teamsCaught
        
        if let checkinsAsString = record["teamCheckins"] as? [String: String] {
            self.teamCheckins = checkinsAsString.mapValues({ (string) -> Date in string.toDateTime()})
        }
        
        if let locations = record["teamLocations"] as? [String: [String: Any]] {
            for (teamID, locationData) in locations {
                teamLocations[teamID] = CLLocation(key: "", record: locationData)
            }
        }
        
        
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
    var startHide: Date?
    var hidingTime: TimeInterval = TimeInterval(exactly: 15 * 60)!
    var roundStatus: RoundStatus! = RoundStatus.notStarted
    var roundIsActive: Bool {
        return ![RoundStatus.notStarted, RoundStatus.gameOver, RoundStatus.seekerHidingDuration].contains(self.roundStatus)
    }
    
    var seeker: Team?
    var winners: [Team] {
        if teamsCaught.count == self.parentGame.teams.count - 1 {
            guard let seeker = self.seeker else { return [] }
            return [seeker]
        } else {
            return Array(self.parentGame.teams.values).filter({ (team) -> Bool in return !teamsCaught.keys.contains(team.uid) && team.uid != seeker?.uid})
        }
    }
    
    // Team States
    var teamsCaught = [String: String]() // TeamID + Team Name
    var teamCheckins = [String: Date]()
    var teamLocations = [String: CLLocation]()
    
}

class RoundStatus: Equatable {
    static func == (lhs: RoundStatus, rhs: RoundStatus) -> Bool {
        return lhs.description == rhs.description
    }
    
    static let notStarted = RoundStatus(repr: "Waiting for Admin to start round")
    static let seekerHidingDuration = RoundStatus(repr: "Waiting for Seekers to start hiding countdown", seekHelp: "Set a hiding period")
    static let hiding = RoundStatus(repr: "Hide!", seekHelp: "Wait for teams to hide")
    static let seek = RoundStatus(repr: "Try not to be found", seekHelp: "Find the hidden teams!")
    static let seekWithGPS = RoundStatus(repr: "GPS is live! Stay hidden or stay on the move!", seekHelp: "Use the GPS to your advantage")
    static let gameOver = RoundStatus(repr: "Game Over")
    
    static let states = [notStarted, seekerHidingDuration, hiding, seek, seekWithGPS, gameOver]
    
    var description: String
    var seekDescription: String
    
    
    init(repr: String) {
        description = repr
        seekDescription = repr
    }
    
    init(repr: String, seekHelp: String) {
        description = repr
        seekDescription = seekHelp
    }
    
    
}

extension CLLocation {
    func createPushable() -> [String : Any?] {
        var ret = [String: Any?]()
        ret["coord"] = self.coordinate.createPushable()
        ret["accuracy"] = self.horizontalAccuracy.magnitude
        ret["time"] = self.timestamp.description
        
        return ret
        
    }
    
    convenience init(key: String, record: [String : Any?]) {
        let time = (record["time"] as! String).toDateTime()
        let coord = record["coord"] as! [String: Any]
        let radius = record["accuracy"] as! Double
        
        self.init(coordinate: CLLocationCoordinate2D(key: "", record: coord), altitude: 0, horizontalAccuracy: radius, verticalAccuracy: 0, timestamp: time)
    }
    
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
