//
//  FirebaseAPI-game.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/25/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

extension FirebaseAPIClient {
    
    static func uploadGame(game: Game, withPhoto: Bool = false, success: @escaping () -> (), fail: @escaping () -> ()) {
        // If uploading the photo, asynchronously attempt to do so. Ignore result
        if withPhoto {
            guard let img = game.img else {
                fail()
                return
            }
            uploadGamePhoto(forGame: game, withImage: img, success: {}, fail: {})
        }
        updateRemoteGame(game: game, success: success, fail: fail)
    }
    
    static func updateRemoteGame(game: Game, success: @escaping () -> (), fail: @escaping () -> ()) {
        let ref = Database.database().reference()
        let gameRef = ref.child("games")
        
        let val = game.createPushable()
        
        gameRef.child(game.uid).setValue(val, withCompletionBlock: { (err, ref) in
            if let error = err {
                debugPrint(error)
                fail()
                return
            }
            success()
        })
    }
    
    
    static func uploadGamePhoto(forGame: Game, withImage: UIImage, success: @escaping () -> (), fail: @escaping () -> ()) {
        let image_directory = Storage.storage().reference().child("gamePhotos")
        let photoRef = image_directory.child(forGame.uid)
        guard let photoData = withImage.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        photoRef.putData(photoData, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                // Uh-oh, an error occurred!
                debugPrint("error with photo upload")
                fail()
                return
            }
            success()
        }
    }
    
    static func getGame(withId: String, completion: @escaping (Game?) -> ()) {
        let ref = Database.database().reference().child("games").child(withId)
        
        ref.observeSingleEvent(of: .value) { (snap) in
            guard let data = snap.value as? [String: Any?] else {
                completion(nil)
                return
            }
            let gm = Game(key: withId, record: data)
            
            let photoTarget = Storage.storage().reference().child("gamePhotos").child(gm.uid)
            photoTarget.getData(maxSize: 2 * 1024 * 1024, completion: { (data, err) in
                if let photoData = data {
                    if let img = UIImage(data: photoData) {
                        gm.img = img
                    }
                }
                completion(gm)
            })
        }
    }
    
    static func getAllGames(withIDs: [String], completion: @escaping ([Game]) -> ()) {
        if withIDs.count == 0 {
            completion([])
        }
        
        var gamesDownloaded: [Game] = []
        var failedRequests = 0
        for gameID in withIDs {
            getGame(withId: gameID) { (potentialGame) in
                if let game = potentialGame {
                    gamesDownloaded.append(game)
                } else {
                    failedRequests += 1
                }
                if gamesDownloaded.count == withIDs.count - failedRequests {
                    gamesDownloaded.sort()
                    completion(gamesDownloaded)
                }
            }
        }
        
    }
    
    static func updateGame(_ game: Game, completion: @escaping () -> ()) {
        let ref = Database.database().reference().child("games").child(game.uid)
        
        ref.observeSingleEvent(of: .value) { (snap) in
            guard let data = snap.value as? [String: Any?] else {
                completion()
                return
            }
            game.updateThisGame(key: game.uid, record: data)
            completion()
        }
    }
    
    static func sendGameInvitation(to: User, forGame: Game, success: @escaping() -> (), fail: @escaping() -> ()) {
        // Add the player status to the game
        if to.uid.starts(with: "temp") {
            forGame.playerStatus[to.uid] = .playing // Assume playing since not going to respond
            forGame.players.append(to)
            updateRemoteGame(game: forGame, success: {
                success()
            }, fail: {fail()})
            return
        }
        forGame.playerStatus[to.uid] = .invited
        forGame.players.append(to)
        // Put a snippet of the game in their inbox
        to.inbxGaReqs[forGame.uid] = forGame.title
        
        updateRemoteGame(game: forGame, success: {
            updateRemoteUser(usr: to, success: {
                success()
            }, fail: {fail()})
        }, fail: {fail()})
    }
    
    static func gameInvitationAccepted(by: User, forGame: Game, success: @escaping() -> (), fail: @escaping() -> ()) {
        by.inbxGaReqs.removeValue(forKey: forGame.uid)
        by.gameIDs[forGame.uid] = forGame.admin_username
        by.games.append(forGame)
        
        forGame.playerStatus[by.uid] = .playing
        updateRemoteGame(game: forGame, success: {
            updateRemoteUser(usr: by, success: {
                success()
            }, fail: {fail()})
        }, fail: {fail()})
    }
    
    static func gameInvitationRejected(by: User, forGame: Game, success: @escaping() -> (), fail: @escaping() -> ()) {
        by.inbxGaReqs.removeValue(forKey: forGame.uid)
        
        forGame.playerStatus.removeValue(forKey: by.uid)
        forGame.players.remove(at: forGame.players.index(of: by)!)
        
        updateRemoteGame(game: forGame, success: {
            updateRemoteUser(usr: by, success: {
                success()
            }, fail: {fail()})
        }, fail: {fail()})
    }
    
    static func gameLeft(by: User, fromGame: Game, success: @escaping() -> (), fail: @escaping() -> ()) {
        
        if fromGame.admin == by {
            success()
            return
        }
        
        if !by.uid.starts(with: "temp") {
            by.gameIDs.removeValue(forKey: fromGame.uid)
            
            if fromGame.playerStatus[by.uid] != PlayerStatus.invited {
                by.games.remove(at: by.games.index(of: fromGame)!)
            } else {
                by.inbxGaReqs.removeValue(forKey: fromGame.uid)
            }
        }
        
        fromGame.playerStatus.removeValue(forKey: by.uid)
        fromGame.players.remove(at: fromGame.players.index(of: by)!)
        
        for team in fromGame.teams.values {
            team.memberIDs.removeValue(forKey: by.uid)
        }
        
        updateRemoteGame(game: fromGame, success: {
            if !by.uid.starts(with: "temp") {
                updateRemoteUser(usr: by, success: {
                    success()
                }, fail: {fail()})
            } else {
                success()
            }
            
        }, fail: {fail()})
        
    }
    
    static func sendGameInvitation(to: [User], forGame: Game, success: @escaping() -> (), fail: @escaping() -> ()) {
        if to.count == 0 {
            success()
        }
        
        var successes = 0
        var responses = 0
        
        
        for user in to {
            sendGameInvitation(to: user, forGame: forGame, success: {
                successes += 1
                responses += 1
                
                if responses >= to.count {
                    if successes == responses {
                        success()
                    } else {
                        fail()
                    }
                }
            }) {
                responses += 1
                if responses >= to.count {
                    if successes == responses {
                        success()
                    } else {
                        fail()
                    }
                }
            }
        }
    }
    
    
    static func updatePhoto(forTeam: Team, inGame: Game, completion: @escaping () -> () ) {
        let image_directory = Storage.storage().reference().child("teamPhotos")
        let photoRef = image_directory.child(forTeam.uid)
        guard let photoData = forTeam.img?.jpegData(compressionQuality: 0.4) else {
            completion()
            return
        }
        
        photoRef.putData(photoData, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                // Uh-oh, an error occurred!
                debugPrint("error with photo upload")
                completion()
                return
            }
            completion()
        }
    }
    
    static func getTeamPhoto(forTeam: Team, completion: @escaping() -> () ) {
        let photoTarget = Storage.storage().reference().child("teamPhotos").child(forTeam.uid)
        photoTarget.getData(maxSize: 2 * 1024 * 1024, completion: { (data, err) in
            if let photoData = data {
                if let img = UIImage(data: photoData) {
                    forTeam.img = img
                }
            }
            completion()
        })
    }
    
}
