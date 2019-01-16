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
import CoreLocation

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
    
    static func updateLocationFor(inRound: String, teamID: String, forGame: String, toLocation: CLLocation, completion: @escaping () -> ()) {
        Database.database().reference().child("games").child(forGame).child("rounds").child(inRound).child("teamLocations").child(teamID).setValue(toLocation.createPushable()) { (err, ref) in
            completion()
        }
        
        
    }
    
    
    
}
