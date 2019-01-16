//
//  Game.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/20/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import iosManagers
class GameSelectionType: Equatable {
    static func == (lhs: GameSelectionType, rhs: GameSelectionType) -> Bool {
        return lhs.description == rhs.description
    }
    
    static let Assigned = GameSelectionType(repr: "Assigned")
    static let Chosen = GameSelectionType(repr: "Chosen")
    static let Randomized = GameSelectionType(repr: "Randomized")
    
    var description: String
    
    
    
    init(repr: String) {
        description = repr
    }
    
    
}

class PlayerStatus: Equatable {
    static func == (lhs: PlayerStatus, rhs: PlayerStatus) -> Bool {
        return lhs.description == rhs.description
    }
    
    static let admin = PlayerStatus("admin")
    static let playing = PlayerStatus("playing")
    static let invited = PlayerStatus("invited")
    
    var description: String
    
    
    
    init(_ repr: String) {
        description = repr
    }
    
    
}




class Game: FirebaseReady, Comparable {
    static func < (lhs: Game, rhs: Game) -> Bool {
        return lhs.datetime < rhs.datetime
    }
    
    static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    
    // Metadata
    var uid: String!
    var admin_uid: String!
    var admin_username: String!
    var admin: User? {
        for player in players {
            if player.uid == admin_uid {
                return player
            }
        }
        return nil
    }
    
    // Summary
    var title: String!
    var datetime: Date!
    var img: UIImage? = nil
    
    // Timing Parameters
    var roundDuration: TimeInterval!
    var checkInDuration: TimeInterval!
    var gpsActivation: TimeInterval!

    // Selection Parameters
    var teamSelection: GameSelectionType!
    var seekSelection: GameSelectionType!
    
    // Players
    var players = [User]()
    var playerStatus = [String: PlayerStatus]() //playerID
    var teams = [String: Team]()
    
    // Rounds
    var rounds = [Round]()
    var currRoundNumber = 0
    var currentRound: Round! {
        return rounds[currRoundNumber]
    }
    
    // Social
    var notificationDevices = [String: String]()
    var chat: Chat?
    
    // Game State
    var active = false
    var finished: Bool {
        return self.rounds.map({ (round) -> Bool in return round.roundStatus == RoundStatus.gameOver}).reduce(true, { (res, nxt) -> Bool in return res && nxt}) && self.rounds.count > 0
    }
    
    
    
    init(gameid: String, admin: User, title: String, datetime: Date, round_checkin_gps durations: [TimeInterval], team_seek decisions: [GameSelectionType], img: UIImage?) {
        self.uid = gameid
        self.admin_uid = admin.uid
        self.admin_username = admin.username
        
        self.title = title
        self.datetime = datetime
        
        self.roundDuration = durations[0]
        self.checkInDuration = durations[1]
        self.gpsActivation = durations[2]

        self.teamSelection = decisions[0]
        self.seekSelection = decisions[1]
        
        self.img = img
        
        self.players.append(admin)
        self.playerStatus[admin.uid] = .admin
    }
    func createPushable() -> [String : Any?] {
        var ret:[String: Any?] = [:]
        ret["uid"] = self.uid
        ret["admin"] = [admin_uid : admin_username]
        
        ret["title"] = self.title
        ret["datetime"] = self.datetime.description
        
        ret["durations"] = [roundDuration.magnitude, checkInDuration.magnitude, gpsActivation.magnitude]
        ret["selections"] = [teamSelection.description, seekSelection.description]
        
        
        
        var playerDict = [String: Any]()
        var playerStatusUpdate = [String: String]()
        for player in players {
            playerDict[player.uid] = player.createPushable()
            playerStatusUpdate[player.uid] = self.playerStatus[player.uid]?.description
        }
        ret["players"] = playerDict
        ret["playerStatus"] = playerStatusUpdate
        
        var teamsPushable: [String: [String: Any?]] = [:]
        for (uid, team) in self.teams {
            teamsPushable[uid] = team.createPushable()
        }
        
        ret["teams"] = teamsPushable
        
        
        var roundsPushable: [String: [String: Any?]] = [:]
        for round in self.rounds {
            roundsPushable[round.uid] = round.createPushable()
        }
        
        ret["rounds"] = roundsPushable
        ret["currRoundNumber"] = currRoundNumber
        
        
        ret["active"] = self.active && !self.finished
        
        ret["notificationDevices"] = self.notificationDevices
        
        return ret
    }
    
    required init(key: String, record: [String : Any?]) {
        updateThisGame(key: key, record: record, loadImages: true)
    }
    
    func updateThisGame(key: String, record: [String: Any?], loadImages: Bool = false) {
        self.uid = key
        
        var tempuid: String = ""
        var tempadm: String = ""
        if let adminRecord = record["admin"] as? [String: String] {
            for (uid, name) in adminRecord {
                tempuid = uid
                tempadm = name
            }
        }
        
        self.admin_uid = tempuid
        self.admin_username = tempadm
        
        self.title = record["title"] as? String ?? "Game by \(tempadm)"
        self.datetime = (record["datetime"] as? String)?.toDateTime() ?? Date.init()
        
        if let durations = record["durations"] as? [Int] {
            self.roundDuration = TimeInterval(exactly:durations[0])
            self.checkInDuration = TimeInterval(exactly:durations[1])
            self.gpsActivation = TimeInterval(exactly:durations[2])
        } else {
            self.roundDuration = .defaultRound
            self.checkInDuration = .defaultCheckin
            self.gpsActivation = .defaultGPS
        }
        
        if let decisions = record["selections"] as? [String] {
            self.teamSelection = GameSelectionType(repr: decisions[0])
            self.seekSelection = GameSelectionType(repr: decisions[1])
        }
        
        // Cache the images
        var images = [String: UIImage]()
        for player in self.players {
            images[player.uid] = player.profilePic
        }
        
        if let playersData = record["players"] as? [String: [String: Any?]] {
            self.players = []
            for (uid, rec) in playersData {
                let usr = User(key: uid, record: rec)
                if let usrProfilePic = images[uid] {
                    usr.profilePic = usrProfilePic
                }
                if (loadImages) {
                    FirebaseAPIClient.getProfilePhotoFor(user: usr) { (img) in
                        usr.profilePic = img
                    }
                }
                
                self.players.append(usr)
            }
        }
        
        if let playerStatusUpdate = record["playerStatus"] as? [String: String] {
            self.playerStatus = [:]
            for (uid, status) in playerStatusUpdate {
                self.playerStatus[uid] = PlayerStatus(status)
            }
        }
        
        // Cache Images
        var teamImages = [String: UIImage]()
        for (uid, loadedTeam) in self.teams {
            teamImages[uid] = loadedTeam.img
        }
        
        if let teamData = record["teams"] as? [String: [String: Any?]] {
            self.teams = [:]
            for (uid, rec) in teamData {
                let team = Team(key: uid, record: rec)
                
                if let teamPic = teamImages[uid] {
                    team.img = teamPic
                }
                if (loadImages) {
                    FirebaseAPIClient.getTeamPhoto(forTeam: team) {}
                }
                self.teams[uid] = team
            }
        }
        
        if let roundData = record["rounds"] as? [String: [String: Any?]] {
            self.rounds = []
            for (uid, rec) in roundData {
                let round = Round(key: uid, record: rec, parentGameWithTeams: self)
                self.rounds.append(round)
            }
            self.rounds.sort()
        }
        self.currRoundNumber = record["currRoundNumber"] as? Int ?? 0
        
        self.active = record["active"] as? Bool ?? false
        
        self.notificationDevices = record["notificationDevices"] as? [String: String] ?? [:]
        

    }
    
    func setGamePhoto(to: UIImage, updateRemote: Bool, completion: @escaping () -> () = {}) {
        self.img = to
        if updateRemote {
            FirebaseAPIClient.uploadGamePhoto(forGame: self, withImage: to, success: completion, fail: {})
        }
    }
    
    func getPlayerStatus(forUser: User) -> PlayerStatus {
        return self.playerStatus[forUser.uid]!
    }
    
    func getTeamFor(player: User) -> Team? {
        for team in self.teams.values {
            for memberID in team.memberIDs.keys {
                if memberID == player.uid {
                    return team
                }
            }
        }
        
        return nil
        
    }
    
    
    
    
}
