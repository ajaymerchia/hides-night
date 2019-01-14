//
//  GamesVC-logic.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/22/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import iosManagers
import FirebaseDatabase

extension GamesVC {
    func setUpChangeListener() {
        Database.database().reference().child("games").observe(.childChanged) { (snap) in
            guard let data = snap.value as? [String: Any?] else {
                return
            }
            
            guard let uid = data["uid"] as? String else { return }
            
            for game in self.user.games {
                if game.uid == uid {
                    game.updateThisGame(key: uid, record: data)
                    self.sortAndDisplayGames()
                }
            }
        }
    }
    
    func getUserFromParent() {
        let parentTab = (self.tabBarController as! TabBarVC)
        self.user = parentTab.user
    }

    func sortAndDisplayGames() {
        // Sort the Games
        tableData = [[], [], []]
        for game in self.user.games {
            if game.active {
                tableData[0].append(game)
            } else if game.datetime > Date.init() {
                tableData[1].append(game)
            } else {
                tableData[2].append(game)
            }
        }
        
        // Load only the appropriate header
        sectionsToDisplay = []
        for i in 0..<tableData.count {
            let data = tableData[i]
            if data.count > 0 {
                sectionsToDisplay.append(GamesVC.possibleHeaders[i])
            }
        }
        
        gamesTable.reloadData()
        
    }
    
    func getTableDataFor(section: String) -> [Game]{
        guard let index = GamesVC.possibleHeaders.index(of: section) else {return []}
        return tableData[index]
    }
    
    func getGamesForUI(indexPath: IndexPath) -> [Game] {
        return getTableDataFor(section: sectionsToDisplay[indexPath.section])
    }
    
    func getGameForUI(indexPath: IndexPath) -> Game {
        return getGamesForUI(indexPath: indexPath)[indexPath.row]
    }
    
    

}
