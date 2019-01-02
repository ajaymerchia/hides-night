//
//  GameDetailVC-tableview.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/28/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import iosManagers

extension GameDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentSegSelected {
        case 0:
            return self.game.players.count
        case 1:
            return self.game.teams.count
        default:
            return self.game.rounds.count
        }
        
    }
    
    func heightComputer() -> CGFloat {
        switch currentSegSelected {
        case 0:
            return 50
        case 1:
            return 70
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightComputer()
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch currentSegSelected {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "personCell") as! PersonCell
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }
            cell.awakeFromNib()
            cell.selectionStyle = .none
            
            let playerUser = playerFor(indexPath: indexPath)
            
            cell.initializeCellFrom(data: playerUser , size: CGSize(width: view.frame.width, height: heightComputer()), blackBack: true)
            cell.profilePic.setImage(playerUser.profilePic, for: .normal)
            cell.contentView.backgroundColor = .black
            cell.backgroundColor = .black
            cell.allowsSelect = self.userIsAdmin
            
            cell.status.text = self.game.getPlayerStatus(forUser: playerUser).description
            
            return cell
        case 1:
            // Team Cell Stuff
            let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell") as! GameCell
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }
            
            let team = teamFor(indexPath: indexPath)
            
            cell.awakeFromNib()
            cell.initializeCellFrom(data: team, size: CGSize(width: view.frame.width, height: heightComputer()))
            cell.selectionStyle = .none
            return cell
        default:
            // Round Cell Stuff
            let cell = tableView.dequeueReusableCell(withIdentifier: "roundCell") as! RoundCell
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }
            cell.awakeFromNib()
            cell.initializeCellFrom(data: roundFor(indexPath: indexPath), size: CGSize(width: view.frame.width, height: heightComputer()))
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("selected a cell")
        
        switch currentSegSelected {
        case 0:
            if userIsAdmin {
                let user = playerFor(indexPath: indexPath)
                displayPopup(forUser: user, index: indexPath)
            }
        case 1:
            // Team Cell Stuff
            debugPrint("tapped team")
            teamToShow = teamFor(indexPath: indexPath)
            self.performSegue(withIdentifier: "detail2team", sender: self)
        default:
            // Round Cell Stuff
            roundToShow = roundFor(indexPath: indexPath)
            self.performSegue(withIdentifier: "detail2round", sender: self)
            debugPrint("tapped round")
        }
        
    }
    
    
    func playerFor(indexPath: IndexPath) -> User {
        return self.game.players.sorted()[indexPath.row]
    }
    
    func teamFor(indexPath: IndexPath) -> Team {
        return self.game.teams.values.sorted()[indexPath.row]
    }
    
    func roundFor(indexPath: IndexPath) -> Round {
        return self.game.rounds.sorted()[indexPath.row]
    }
    
    
}
