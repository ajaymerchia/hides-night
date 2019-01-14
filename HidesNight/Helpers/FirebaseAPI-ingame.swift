//
//  FirebaseAPIClient-ingame.swift
//  HidesNight
//
//  Created by Ajay Merchia on 1/13/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

extension FirebaseAPIClient {
    static func checkIn(by: User, forGame: Game, completion: @escaping () -> ()) {
        guard let team = forGame.getTeamFor(player: by) else { completion(); return}
        forGame.currentRound.teamCheckins[team.uid] = Date()
        
        updateRemoteGame(game: forGame, success: {
            completion()
        }) {
            completion()
        }
        
    }
    
    
    
}
