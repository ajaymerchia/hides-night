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
    static func getGame(withId: String, completion: @escaping (Game?) -> ()) {
        let ref = Database.database().reference().child("games").child(withId)
        
        ref.observeSingleEvent(of: .value) { (snap) in
            completion(nil) // FXIME
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
                    completion(gamesDownloaded)
                }
            }
        }
        
    }
}
