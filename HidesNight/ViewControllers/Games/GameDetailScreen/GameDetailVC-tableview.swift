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
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
            
            let playerUser = self.game.players.sorted()[indexPath.row]
            
            cell.initializeCellFrom(data: playerUser , size: CGSize(width: view.frame.width, height: 50), blackBack: true)
            cell.profilePic.setImage(playerUser.profilePic, for: .normal)
            cell.contentView.backgroundColor = .black
            cell.backgroundColor = .black
            cell.allowsSelect = self.userIsAdmin
            
            cell.status.text = self.game.getPlayerStatus(forUser: playerUser).description
            
            return cell
        case 1:
            // Team Cell Stuff
            let cell = tableView.dequeueReusableCell(withIdentifier: "personCell") as! PersonCell
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }
            cell.awakeFromNib()
            cell.selectionStyle = .none
            return cell
        default:
            // Round Cell Stuff
            let cell = tableView.dequeueReusableCell(withIdentifier: "personCell") as! PersonCell
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }
            cell.awakeFromNib()
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("selected a cell")
        
        switch currentSegSelected {
        case 0:
            if userIsAdmin {
                let user = self.game.players.sorted()[indexPath.row]
                displayPopup(forUser: user, index: indexPath)
            }
        case 1:
            // Team Cell Stuff
            debugPrint("tapped team")
        default:
            // Round Cell Stuff
            debugPrint("tapped round")
        }
        
    }
    
    
}
